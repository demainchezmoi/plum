defmodule Plum.AdsImporter.Notifier do
  use GenStage
  require Logger

  ##########
  # Client API
  ##########
  def start_link(pipeline_name) do
    process_name =
      Enum.join([pipeline_name, "Notifier"], "")

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
    upstream =
      Enum.join([pipeline_name, "Importer"], "")

    {
      :consumer,
      pipeline_name,
      subscribe_to: [{String.to_atom(upstream), min_demand: 0, max_demand: 1}]
    }
  end

  def handle_events(_events, _from, pipeline_name) do
    {:noreply, [], pipeline_name}
  end

  ##########
  # Private functions
  ##########
end

