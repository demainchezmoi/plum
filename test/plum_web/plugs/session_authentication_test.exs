defmodule PlumWeb.SessionAuthenticationTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias PlumWeb.Plugs.SessionAuthentication

  @session_key Application.get_env(:plum, :session_key)

  test "don't assign user without session token", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(%{})
      |> SessionAuthentication.call([])
    refute conn.assigns[:current_user]
  end

  test "don't assign user with invalid session token", %{conn: conn} do
    token = "123" 
    conn =
      conn
      |> Plug.Test.init_test_session(%{@session_key => token})
      |> SessionAuthentication.call([])
    refute conn.assigns[:current_user]
  end

  @tag :logged_in
  test "fetches the user and authorizes access with valid session token", %{conn: conn, current_user: current_user} do
    session = insert(:session, user_id: current_user.id)
    conn =
      conn
      |> Plug.Test.init_test_session(%{@session_key => session.token})
      |> SessionAuthentication.call([])
    assert conn.assigns[:current_user] == current_user
  end
end
