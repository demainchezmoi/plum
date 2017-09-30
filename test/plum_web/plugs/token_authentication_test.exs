defmodule Plum.Plugs.TokenAuthenticationTest do
  use PlumWeb.ConnCase
  alias PlumWeb.Plugs.TokenAuthentication
  alias PlumWeb.Endpoint
  import Plum.Factory

  test "don't assign user without token",
  %{conn: conn} do
    conn = conn |> TokenAuthentication.call(%{})
    refute conn.assigns[:current_user]
  end

  test "don't assign user with invalid token",
  %{conn: conn} do
    token = Phoenix.Token.sign(Endpoint, "user", -1)
    conn =
      conn
      |> put_auth_token_in_header(token)
      |> TokenAuthentication.call(%{})
    refute conn.assigns[:current_user]
  end

  test "fetches the user and authorizes access with valid token", %{conn: conn} do
    user = insert(:user)
    token = Phoenix.Token.sign(Endpoint, "user", user.id)
    conn =
      conn
      |> put_auth_token_in_header(token)
      |> TokenAuthentication.call(%{})
    refute conn.halted
    assert conn.assigns.current_user.id == user.id
  end

  defp put_auth_token_in_header(conn, token) do
    conn |> put_req_header("authorization", "Token token=\"#{token}\"")
  end
end
