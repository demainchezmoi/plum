defmodule PlumWeb.Plugs.RequireLoginTest do
  use PlumWeb.ConnCase
  alias PlumWeb.Plugs.RequireLogin

  describe "html case" do
    test "redirects when not logged id", %{conn: conn} do
      conn = conn |> RequireLogin.call({:html, []})
      assert redirected_to(conn) == page_path(conn, :login)
      assert conn.halted
    end

    @tag :logged_in
    test "lets through when logged in", %{conn: conn} do
      conn = conn |> RequireLogin.call({:html, []})
      refute conn.halted
    end

    @tag :logged_in
    test "sends 403 when not admin", %{conn: conn} do
      conn = conn |> RequireLogin.call({:html, ["admin"]})
      assert conn.status == 403
      assert conn.halted
    end

    @tag logged_in: ~w(admin)
    test "lets through when admin", %{conn: conn} do
      conn = conn |> RequireLogin.call({:html, ["admin"]})
      refute conn.halted
    end
  end

  describe "json case" do
    test "sends 401 when not logged id", %{conn: conn} do
      conn = conn |> RequireLogin.call({:json, []})
      assert json_response(conn, 401)
      assert conn.halted
    end

    @tag :logged_in
    test "sends 200 when logged in", %{conn: conn} do
      conn = conn |> RequireLogin.call({:json, []})
      refute conn.status == 403
      refute conn.status == 401
      refute conn.halted
    end

    @tag :logged_in
    test "sends 403 when not admin", %{conn: conn} do
      conn = conn |> RequireLogin.call({:json, ["admin"]})
      assert conn.status == 403
      assert conn.halted
    end

    @tag logged_in: ~w(admin)
    test "sends 200 when admin", %{conn: conn} do
      conn = conn |> RequireLogin.call({:json, ["admin"]})
      refute conn.status == 403
      refute conn.halted
    end
  end

end
