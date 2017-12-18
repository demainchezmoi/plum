defmodule Plum.Aircall do
  require Logger
  alias Plum.Repo
  alias Plum.Sales
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

  def create_aircall_contact(params) do
    post!("contacts", params)
  end

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

  def post!(path, data) do
    path = "#{@base_path}/#{path}"
    body = data |> Poison.encode!
    headers = [{"Content-type", "application/json"}]
    options = request_options()
    {:ok, res} = HTTPoison.post(path, body, headers, options)
    %HTTPoison.Response{body: body} = res
    body |> Poison.decode!
  end

  # =========
  # Webhooks
  # =========

  # @webhook_unhandled_events ~w(
		# contact.deleted
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
    call.answered
		call.archived
		call.assigned
	  call.created
		call.ended
		call.hungup
		contact.created
		contact.updated
	)

  # Contact events

  def handle_webhook(%{"event" => "contact.created", "data" => data}) do
    data
    |> insert_or_update_contact
    |> case do
      {:ok, contact = %Contact{}} ->
        contact |> ensure_plum_contact
      {:error, err} ->
        err |> inspect |> Logger.error
        {:error, err}
    end
  end

  def handle_webhook(%{"event" => "contact.updated", "data" => data}) do
    data
    |> insert_or_update_contact
    |> case do
      {:ok, contact = %Contact{}} ->
        contact |> ensure_plum_contact
      {:error, err} ->
        err |> inspect |> Logger.error
        {:error, err}
    end
  end

  # Call events

  def handle_webhook(%{"event" => "call.answered", "data" => data}) do
    data |> insert_or_update_call
  end

  def handle_webhook(%{"event" => "call.archived", "data" => data}) do
    data |> insert_or_update_call
  end

  def handle_webhook(%{"event" => "call.assigned", "data" => data}) do
    data |> insert_or_update_call
  end

  def handle_webhook(%{"event" => "call.created", "data" => data}) do
    data |> insert_or_update_call
  end

  def handle_webhook(%{"event" => "call.ended", "data" => data}) do
    data |> insert_or_update_call
  end

  def handle_webhook(%{"event" => "call.hungup", "data" => data}) do
    data |> insert_or_update_call
  end

  # Other events

  def handle_webhook(%{"event" => event}) when event in @webhook_handled_events, do: Logger.error("Didn't handle aircall event #{event}")
  def handle_webhook(_), do: nil

  # =========
  # Helpers
  # =========

  defp ensure_plum_contact(contact) do
    case contact |> Repo.preload(:contact) do
      aircall_contact = %Contact{contact: %Sales.Contact{}} ->
        {:existing, aircall_contact}
      aircall_contact ->
        aircall_contact
        |> contact_changeset_from_aircall
        |> Repo.insert
        |> case do
          {:ok, _sales_contact} ->
            {:created, aircall_contact |> Repo.preload(:contact)}
          {:error, err} ->
            err |> inspect |> Logger.error
            {:error, err}
        end
    end
  end

  defp contact_changeset_from_aircall(aircall_contact) do
    params =
      aircall_contact
      |> Map.from_struct
      |> Map.put(:aircall_contact_id, aircall_contact[:id])
      |> Map.put(:origin, "aircall")
    %Sales.Contact{} |> Sales.Contact.changeset(params)
  end

  # defp aircall_changeset_from_contact(sales_contact) do
    # params =
      # sales_contact
      # |> Map.from_struct
      # |> Map.put(:phone_numbers, sales_contact[:phone_numbers] |> Enum.map(& &1 |> Map.from_struct))
      # |> Map.put(:emails, sales_contact[:emails] |> Enum.map(& &1 |> Map.from_struct))
    # %Contact{} |> Contact.changeset(params)
  # end

  defp insert_or_update_contact(data) do
    case Contact |> Repo.get(data["id"]) do
      contact = %Contact{}->
        contact |> Contact.changeset(data) |> Repo.update
      nil ->
        %Contact{} |> Contact.changeset(data) |> Repo.insert
    end
  end

  defp insert_or_update_call(data) do
    data =
      data
      |> handle_belonging_to("number", "numbers", Number, "number_id")
      |> handle_belonging_to("user", "users", User, "user_id")
      |> handle_belonging_to("contact", "contacts", Contact, "contact_id")
      |> handle_belonging_to("assigned_to", "users", User, "assigned_to_id")

    case Call |> Repo.get(data["id"]) do
      call = %Call{}->
        call |> Call.changeset(data) |> Repo.update
      nil ->
        %Call{} |> Call.changeset(data) |> Repo.insert
    end
  end

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
