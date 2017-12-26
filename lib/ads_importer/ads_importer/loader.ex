defmodule Plum.AdsImporter.Loader do
  use GenStage
  alias Plum.AdsImporter.S3Server
  require Logger

  ##########
  # Client API
  ##########
  def start_link(pipeline_name) do
    process_name =
      Enum.join([pipeline_name, "Loader"], "")

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
    {
      :producer_consumer,
      pipeline_name,
      subscribe_to: [{Plum.AdsImporter.Producer, min_demand: 0, max_demand: 1}]
    }
  end

  def handle_events([event] = _events, _from, pipeline_name) do
    # Retrieve file from S3
    ExAws.S3.get_object(event.bucket, event.key) |> ExAws.request |> case do
      {_status, %{body: file}} ->
        {:noreply, [Map.put(event, :file, file)], pipeline_name}
      _ ->
        Logger.warn("File not found, releasing #{event.key}")
        [event] |> S3Server.release
        {:noreply, [], pipeline_name}
    end
  end
end

