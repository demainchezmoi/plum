defmodule PlumWeb.Api.AuthController do
  use PlumWeb, :controller
  alias PlumWeb.Endpoint
  alias Phoenix.Token
  alias Plum.Accounts


  action_fallback PlumWeb.FallbackController

  @doc """
  Generates and sends magic login token if the user can be found.
  """
  def create(conn, %{"email" => email}) do
    Accounts.provide_token(email)
    conn |> send_resp(201, %{status: "Created"} |> Poison.encode!) 
  end

  @doc """
  Login user via magic link token.
  Sets the given user as `current_user` and updates the session.
  """
  def show(conn, %{"token" => token}) do
    with {:ok, user} <- Accounts.verify_token_value(token) do
      token = Token.sign(Endpoint, "user", user.id)
      conn |> render("show.json", %{token: token})
    end
  end
end
