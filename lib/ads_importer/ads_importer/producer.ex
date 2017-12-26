defmodule Plum.AdsImporter.Producer do
  use GenStage
  alias Plum.AdsImporter.{Producer, S3Server}

  ##########
  # Client API
  ##########
  def start_link do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def enqueue({_count, _events} = message) do
    GenServer.cast(Producer, {:events, message})
  end


  ##########
  # Server callbacks
  ##########
  def init(0) do
    {:producer, 0}
  end

  def handle_demand(demand, state) when demand > 0 do
    new_demand = demand + state
    {count, events} = take(new_demand)
    {:noreply, events, new_demand - count}
  end

  def handle_cast({:events, {count, events}}, state) do
    {:noreply, events, state - count}
  end

  defp take(demand) do
    S3Server.pull(demand)
  end
end
