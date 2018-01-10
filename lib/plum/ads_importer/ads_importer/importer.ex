defmodule Plum.AdsImporter.Importer do
  use GenStage

  alias Ecto.Changeset
  alias Plum.AdsImporter.{S3Server}
  alias Plum.Geo
  alias Plum.Geo.{City, Land, LandAd}
  alias Plum.Repo
  alias Plum.TaskSupervisor
  alias Task.Supervisor

  require Logger

  # ================
  # Client API
  # ================
  def start_link(pipeline_name) do
    process_name = Enum.join([pipeline_name, "Importer"], "")
    GenStage.start_link(
      __MODULE__,
      pipeline_name,
      name: String.to_atom(process_name)
    )
  end

  # ================
  # Server callbacks
  # ================
  def init(pipeline_name) do
    upstream = Enum.join([pipeline_name, "Loader"], "")
    {:producer_consumer, pipeline_name, subscribe_to: [{String.to_atom(upstream), min_demand: 0, max_demand: 1}]}
  end


  def handle_events([event], _from, pipeline_name) do
    file_task = Task.async(fn -> handle_event(event) end)
    # S3Server.release_and_delete(events)
    forward_events = Task.await(file_task, 10 * 60 * 1_000)
    {:noreply, forward_events, pipeline_name}
  end

  # ================
  # Private functions
  # ================
  defp handle_event(%{file: file} = event) do
    %{ref: ref} = Supervisor.async_nolink(TaskSupervisor, fn -> process_file(file) end)
    collect_results(ref, event)
  end

  def collect_results(ref, event, forward_events \\ []) do
    receive do
      {:DOWN, ^ref, _, _, :normal} ->
        Logger.debug("[ok] import handle_object succeeded, releasing")
        S3Server.release_and_delete([event])
        forward_events

      {:DOWN, ^ref, _, _, message} ->
        Logger.error("[error] import handle_object failed #{inspect message}")
        S3Server.release_and_delete([event])
        []

      {^ref, reply} ->
        collect_results(ref, event, reply)
    end
  end

  defp process_file(file) do
    data = file |> Poison.decode!
    with ads when is_list(ads) and length(ads) > 0 <- data["ads"] do
      ads |> Enum.map(&import_ad/1)
    else
      [] ->
        Logger.warn("[warn] Empty lands import file #{inspect data}")
      error ->
        Logger.error("[error] Unprocessable lands import file #{inspect error}")
    end
  end

  defp attach_city(struct) do
    Logger.debug("attach_city to struct #{inspect struct}")

    with cp when is_binary(cp) <- struct["raw_postal_code"],
         name when is_binary(name) <- struct["raw_city_name"],
         dep <- cp |> String.slice(0..1),
         %City{id: city_id} <- Geo.find_matching_city(name, dep)
    do
      struct |> Map.put("city_id", city_id)
    else
      _ -> struct
    end
  end

  defp import_ad(ad) do
    Logger.debug("Importing ad #{inspect ad}")

    case Geo.get_ad_by(%{origin: ad["origin"], link: ad["link"]}) do
      %LandAd{} ->
        {:ok, :ad_existing}
      nil ->
        case Geo.find_matching_land(ad) do
          %Land{id: id} ->
            ad
            |> Map.put("land_id", id)
            |> Geo.create_land_ad
            |> case do
              {:ok, _} -> {:ok, :ad_inserted}
              _ -> {:error, :ad_not_inserted}
            end

          nil ->
            ad_changeset = %LandAd{} |> LandAd.changeset(ad)
            params = ad |> attach_city

            %Land{}
            |> Land.changeset(params)
            |> Changeset.put_assoc(:ads, [ad_changeset])
            |> Repo.insert
            |> case do
              {:ok, _} -> {:ok, :land_inserted}
              _ -> {:error, :land_not_inserted}
            end
        end
    end
  end
end
