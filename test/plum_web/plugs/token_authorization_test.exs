defmodule Plum.Plugs.TokenAuthorizationTest do
  use PlumWeb.ConnCase
  alias PlumWeb.Plugs.TokenAuthorization
  alias PlumWeb.Endpoint

  test "forbid access without token",
  %{conn: conn} do
    conn = conn |> TokenAuthorization.call(%{})
    assert conn.status == 401
    assert conn.halted
  end

  test "forbid access for invalid token",
  %{conn: conn} do
    token = Phoenix.Token.sign(Endpoint, "user", -1)
    conn =
      conn
      |> Map.update(:body_params, %{"token" => token}, fn p -> Map.put(p, "token", token) end)
      |> TokenAuthorization.call(%{})
    assert conn.status == 401
    assert conn.halted
  end

  @tag :logged_in
  test "fetches the user and authorizes access with valid token",
  %{conn: conn, current_user: current_user} do
    token = Phoenix.Token.sign(Endpoint, "user", current_user.id)
    conn =
      conn
      |> Map.update(:body_params, %{"token" => token}, fn p -> Map.put(p, "token", token) end)
      |> TokenAuthorization.call(%{})
    refute conn.halted
    assert conn.assigns.current_user.id == current_user.id
  end
end

