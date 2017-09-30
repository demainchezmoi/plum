defmodule Plum.Plugs.TokenAuthenticationTest do
  use PlumWeb.ConnCase
  alias PlumWeb.Plugs.TokenAuthentication
  alias PlumWeb.Endpoint

  test "don't assign user without token",
  %{conn: conn} do
    conn = conn |> TokenAuthentication.call(%{})
    refute conn.assigns[:current_user]
  end

  test "don't assign user with invalid token",
  %{conn: conn} do
    token = Phoenix.Token.sign(Endpoint, "user", -1)
    refute conn.assigns[:current_user]
  end

  @tag :logged_in
  test "fetches the user and authorizes access with valid token",
  %{conn: conn, current_user: current_user} do
    token = Phoenix.Token.sign(Endpoint, "user", current_user.id)
    conn =
      conn
      |> Map.update(:body_params, %{"token" => token}, fn p -> Map.put(p, "token", token) end)
      |> TokenAuthentication.call(%{})
    refute conn.halted
    assert conn.assigns.current_user.id == current_user.id
  end
end

