defmodule PlumWeb.Plugs.SessionAuthentication do

  import  Plug.Conn
  alias Plum.Accounts
  alias Plum.Accounts.Session

  @session_key Application.get_env(:plum, :session_key)

  def init(_), do: :ok

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> get_session_data
      |> maybe_load_user
    end
  end

  defp get_session_data(conn) do
    {conn, get_session(conn, @session_key)}
  end

  defp maybe_load_user({conn, token}) when is_nil(token), do: conn
  defp maybe_load_user({conn, token}) do
    case Accounts.get_session_by(token, :token) do
      %Session{user_id: user_id} ->
        conn |> assign(:current_user, Accounts.get_user!(user_id))
      nil ->
        conn
    end
  end
end
