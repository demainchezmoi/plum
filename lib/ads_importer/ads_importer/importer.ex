defmodule Plum.AdsImporter.Importer do

  use GenStage
  alias Plum.AdsImporter.{S3Server}

  alias Ecto.Changeset
  alias Plum.TaskSupervisor
  alias Task.Supervisor

  import Ecto.Query

  require Logger

  ##########
  # Client API
  ##########
  def start_link(pipeline_name) do
    process_name = Enum.join([pipeline_name, "Importer"], "")
    GenStage.start_link(
      __MODULE__,
      pipeline_name,
      name: String.to_atom(process_name)
    )
  end

  ##########
  # Server callbacks
  ##########
  def init(pipeline_name) do
    upstream = Enum.join([pipeline_name, "Loader"], "")
    {:producer_consumer, pipeline_name, subscribe_to: [{String.to_atom(upstream), min_demand: 0, max_demand: 1}]}
  end


  def handle_events([event], _from, pipeline_name) do
    file_task = Task.async(fn -> handle_event(event) end)
    # S3Server.release_and_delete(events)
    forward_events = Task.await(file_task, 3_600_000)
    forward_events |> IO.inspect
    {:noreply, Task.await(file_task, 3_600_000), pipeline_name}
  end

  ########
  # Private functions
  ########
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
        # TODO instead, move errored file to error bucket
        Logger.error("[error] import handle_object failed #{inspect message}")
        S3Server.release_and_delete([event])
        []

      {^ref, reply} ->
        collect_results(ref, event, reply)
    end
  end

  defp process_file(file) do
    data = file |> Poison.decode!
    # TODO import lands
  end
end

