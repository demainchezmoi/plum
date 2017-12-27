defmodule Plum.AdsImporter.S3Server do
  use Supervisor
  alias Plum.AdsImporter.{Producer}
  require Logger

  ##########
  # Client API
  ##########
  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def pull(count) do
    limited_count = min(10, count)

    # Cancel any running loops
    children =
			Task.Supervisor.children(Plum.AdsImporter.S3Server.TaskSupervisor)

    terminate_servers(children)

    # Start a new loop
    {:ok, _pid} =
			Task.Supervisor.start_child(Plum.AdsImporter.S3Server.TaskSupervisor, fn -> loop(limited_count, 0) end)

    {0, []}
  end

  def release_and_delete(messages) do
    messages |> release
    messages |> delete
  end

  def release([]), do: :ok
  def release(messages) do
    receipts =
      messages
      |> Enum.map(fn(message)-> %{
        receipt_handle: Map.get(message, :receipt_handle),
        id: Map.get(message, :id)
      } end)

    queue()
    |> ExAws.SQS.delete_message_batch(receipts)
    |> ExAws.request
    |> case do
      {:ok, _} -> :ok
      {:error, error} -> error |> inspect |> Logger.error
    end
  end

  def delete([]), do: :ok
  def delete(messages) do
    bucket()
    |> ExAws.S3.delete_multiple_objects(messages |> Enum.map(& &1.key))
    |> ExAws.request
    |> case do
      {:ok, _} -> :ok
      {:error, error} -> error |> inspect |> Logger.error
    end
  end

  ##########
  # Server callbacks
  ##########
  def init(:ok) do
    children = [
      supervisor(Task.Supervisor, [[name: Plum.AdsImporter.S3Server.TaskSupervisor]])
    ]
    opts = [strategy: :one_for_one, name: SQSServerSupervisor]
    supervise(children, opts)
  end


  ##########
  # Private functions
  ##########
  defp loop(count, _runs) when count == 0, do: Process.exit(self(), :normal)
  defp loop(count, runs) do
    sqs_options =
      [wait_time_seconds: 2, max_number_of_messages: count]

    {_status, response} =
      ExAws.SQS.receive_message(queue(), sqs_options) |> ExAws.request

    events =
      response
      |> Map.get(:body)
      |> Map.get(:messages)
    	|> process_messages

    if length(events) > 0 do
      Producer.enqueue({length(events), events})
    end

    if length(events) == count do
      Process.exit(self(), :normal)
    else
      :timer.sleep(5000)
      loop(count - length(events), runs + 1)
    end
  end

  defp process_messages([]), do: []
  defp process_messages(results) do
    results |> Enum.map(fn(result) ->
      {bucket, key} =
        result
      	|> Map.get(:body)
      	|> Poison.Parser.parse
      	|> get_path

      %{
        bucket: bucket,
        key: key,
        receipt_handle: result |> Map.get(:receipt_handle),
        id: result |> Map.get(:message_id),
      }
    end)
  end

  defp get_path({:error, _}), do: []
  defp get_path({:ok, json}) do
    Logger.debug("Getting s3 path from #{json |> inspect}")
    s3 =
      json
    	|> Map.get("Records")
    	|> List.first         # Assumes each SQS message contains a record for one S3 file
    	|> Map.get("s3")

    bucket =
      s3
    	|> Map.get("bucket")
    	|> Map.get("name")

    key =
      s3
    	|> Map.get("object")
    	|> Map.get("key")

    {bucket, key}
  end

  defp terminate_servers([]), do: :ok
  defp terminate_servers([h|t]) do
    Process.exit(h, :kill)
    terminate_servers(t)
  end

  defp queue, do: Application.get_env(:plum, :land_ads_sqs_queue)
  defp bucket, do: Application.get_env(:plum, :land_ads_s3_bucket)
end
