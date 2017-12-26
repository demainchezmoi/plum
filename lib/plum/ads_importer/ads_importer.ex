defmodule Plum.AdsImporter do

  # Producer
  # |> Loader     |
  # |> Importer   |-> Supervised by ConsumerSupervisor
  # |> Notifier   |

  # https://github.com/sillypog/sqs-s3-genstage-app/tree/sqs-step-9-concurrent-file-processing

  use Supervisor

  alias Plum.AdsImporter.S3Server
  alias Plum.AdsImporter.Producer
  alias Plum.AdsImporter.ConsumerSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do

    children = [
      worker(S3Server, []),
      worker(Producer, []),
      supervisor(ConsumerSupervisor, ["Pipeline1"], id: 1),
      # supervisor(ConsumerSupervisor, ["Pipeline2"], id: 2)
    ]

    opts = [strategy: :one_for_one, name: ApplicationSupervisor]
    supervise(children, opts)
  end
end
