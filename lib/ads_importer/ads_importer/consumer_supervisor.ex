defmodule Plum.AdsImporter.ConsumerSupervisor do

  use ConsumerSupervisor

  def start_link(name) do
    Supervisor.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def init(pipeline_name) do

    children = [
      worker(Plum.AdsImporter.Loader, [pipeline_name]),
      worker(Plum.AdsImporter.Importer, [pipeline_name]),
      worker(Plum.AdsImporter.Notifier, [pipeline_name])
    ]

    opts = [strategy: :one_for_one, name: "ConsumerSupervisor"]
    supervise(children, opts)
  end
end
