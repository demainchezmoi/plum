defmodule PlumWeb.Api.LandControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory

  describe "index" do
    setup [:create_land]

    @tag :logged_in
    test "lists all lands when logged in", %{conn: conn, token: token} do
      conn = get conn, api_land_path(conn, :index), token: token
      assert json_response(conn, 200)
    end

    test "doesn't list all lands when not logged in", %{conn: conn} do
      conn = get conn, api_land_path(conn, :index)
      assert json_response(conn, 401)
    end
  end

  defp create_land(_) do
    land = insert(:land)
    {:ok, land: land}
  end
end
