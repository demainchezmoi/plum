defmodule Plum.Aircall do

  require Logger

  alias Plum.Repo
  alias Plum.Aircall.{
    Call,
    Contact,
    Number,
    User
  }

  @base_path "https://api.aircall.io/v1"

  # =========
  # Api
  # =========

  def ping, do: get!("ping")

  def get_one(resource, field, id) do
    options = request_options()
    with {:ok, res} <- HTTPoison.get("#{@base_path}/#{resource}/#{id}", [], options),
      %HTTPoison.Response{body: body} <- res,
      {:ok, decoded_body} <- body |> Poison.decode,
      data when not is_nil(data) <- decoded_body |> Map.get(field)
    do
      {:ok, data}
    else
      _ -> :error
    end
  end

  def get!(path, params \\ []) do
    options = request_options() |> Keyword.put(:params, params)
    {:ok, res} = HTTPoison.get("#{@base_path}/#{path}", [], options)
    %HTTPoison.Response{body: body} = res
    body |> Poison.decode!
  end

  # =========
  # Webhooks
  # =========

  # @webhook_unhandled_events ~w(
		# call.answered
		# call.archived
		# call.assigned
		# call.ended
		# call.hungup
		# contact.created
		# contact.deleted
		# contact.updated
		# number.closed
		# number.created
		# number.deleted
		# number.opened
		# user.closed
		# user.connected
		# user.created
		# user.deleted
		# user.disconnected
		# user.opened
  # )a

	@webhook_handled_events ~w(
		call.created
	)

  def handle_webhook(%{"event" => "call.created", "data" => data}) do
    data =
      data
      |> handle_belonging_to("number", "numbers", Number, "number_id")
      |> handle_belonging_to("user", "users", User, "user_id")
      |> handle_belonging_to("contact", "contacts", Contact, "contact_id")
      |> handle_belonging_to("assigned_to", "users", User, "assigned_to_id")
    %Call{} |> Call.changeset(data)
  end

  def handle_webhook(%{"event" => event}) when event in @webhook_handled_events, do: Logger.error("Unhandled aircall event #{event}")
  def handle_webhook(_), do: nil

  # =========
  # Helpers
  # =========

  defp handle_belonging_to(data, field, resource, struct, assoc_field) do
    with %{"id" => id} <- data[field], :ok <- ensure_exists(struct, id, resource, field) do
      data |> Map.put(assoc_field, id)
    else
      _ -> data |> Map.put(assoc_field, nil)
    end
  end

  defp ensure_exists(struct, id, resource, field) do
    case struct |> Repo.get(id) do
      nil ->
        with {:ok, data} <- get_one(resource, field, id),
          {:ok, _} <- apply(struct, :changeset, [struct.__struct__, data]) |> Repo.insert
        do
          :ok
        else
          _ -> :error
        end
      _ -> :ok
    end
  end

  defp req_user, do: Application.get_env(:plum, :aircall_api_id)
  defp req_passowrd, do: Application.get_env(:plum, :aircall_api_token)
  defp request_options, do: [hackney: [basic_auth: {req_user(), req_passowrd()}]]

end
