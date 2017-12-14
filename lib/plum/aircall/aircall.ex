defmodule Plum.Aircall do
  alias Plum.Aircall.Call
  require Logger

  @base_path "https://api.aircall.io/v1"

  # =========
  # Api
  # =========

  def ping, do: get("ping")
  def list_calls(params \\ []), do: get("calls", params)
  def list_numbers(params \\ []), do: get("numbers", params)
  def list_contacts(params \\ []), do: get("contacts", params)

  # =========
  # Webhooks
  # =========

  def handle_webhook(%{"event" => "call.answered", "data" => data}) do
    call = Call.changeset(%Call{}, data) |> Ecto.Changeset.apply_changes
    Logger.info(call)
  end

  def handle_webhook(_), do: nil

  # =========
  # Helpers
  # =========

  defp req_user, do: Application.get_env(:plum, :aircall_api_id)
  defp req_passowrd, do: Application.get_env(:plum, :aircall_api_token)
  defp request_options, do: [hackney: [basic_auth: {req_user(), req_passowrd()}]]

  defp get(path, params \\ []) do
    options = request_options() |> Keyword.put(:params, params)
    {:ok, res} = HTTPoison.get("#{@base_path}/#{path}", [], options)
    %HTTPoison.Response{body: body} = res
    body |> Poison.decode!
  end
end
