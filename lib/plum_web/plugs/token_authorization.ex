defmodule PlumWeb.Plugs.TokenAuthorization do
  alias Plum.Api.ErrorView
  alias PlumWeb.Endpoint
  alias Plum.Repo
  alias Plum.Accounts.User
  alias Phoenix.Controller
  alias Phoenix.Token
  alias Plug.Conn

  def init(_), do: :ok

  def call(conn, _params) do
    with {:ok, token} <- find_token(conn),
         {:ok, user_id} <- verify_token(token),
         user = %User{} <- fetch_user(user_id)
    do
      conn |> Conn.assign(:current_user, user)
    else
      _ ->
        conn
        |> Conn.put_status(:unauthorized)
        |> Controller.render(ErrorView, "401.json")
        |> Conn.halt
    end
  end

  def fetch_user(user_id), do: User |> Repo.get(user_id)

  def verify_token(token) do
    case Token.verify(Endpoint, "user", token, max_age: 1209600) do
      {:ok, token} -> {:ok, token}
      _ -> Token.verify(Endpoint, "api_key", token)
    end
  end

  def find_token(conn) do
    case conn.body_params do
      %{"token" => token} -> {:ok, token}
      _ ->
        conn = conn |> Conn.fetch_query_params
        case conn.query_params do
          %{"token" => token} -> {:ok, token}
          _ -> :error
        end
    end
  end
end

