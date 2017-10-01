defmodule PlumWeb.Plugs.TokenAuthentication do
  alias PlumWeb.Endpoint
  alias Plum.Repo
  alias Plum.Accounts.User
  alias Phoenix.Token
  alias Plug.Conn

  def init(_), do: :ok

  def call(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      with auth_header = Conn.get_req_header(conn, "authorization"),
           {:ok, token}   <- parse_token(auth_header),
           {:ok, user_id} <- verify_token(token),
           user = %User{} <- fetch_user(user_id)
      do
        conn |> Conn.assign(:current_user, user)
      else
        _ -> conn
      end
    end
  end

  def fetch_user(user_id), do: User |> Repo.get(user_id)

  defp parse_token(["Token token=" <> token]), do: {:ok, String.replace(token, "\"", "")}
  defp parse_token(_non_token_header), do: :error

  def verify_token(token) do
    case Token.verify(Endpoint, "user", token, max_age: 1209600) do
      {:ok, token} -> {:ok, token}
      _ -> Token.verify(Endpoint, "api_key", token)
    end
  end
end
