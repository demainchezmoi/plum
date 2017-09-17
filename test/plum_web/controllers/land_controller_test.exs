defmodule PlumWeb.LandControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory

  describe "index" do
    @tag :logged_in
    test "lists all lands", %{conn: conn} do
      conn = get conn, land_path(conn, :index)
      assert html_response(conn, 200)
    end
  end

  describe "new land" do
    @tag :logged_in
    test "renders form", %{conn: conn} do
      conn = get conn, land_path(conn, :new)
      assert html_response(conn, 200)
    end
  end

  describe "create land" do
    @tag :logged_in
    test "redirects to show when data is valid", %{conn: conn} do
      conn1 = post conn, land_path(conn, :create), land: params_for(:land) 

      assert %{id: id} = redirected_params(conn1)
      assert redirected_to(conn1) == land_path(conn, :show, id)

      conn2 = get conn, land_path(conn, :show, id)
      assert html_response(conn2, 200)
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      invalid_params = params_for(:land) |> Map.delete(:surface)
      conn = post conn, land_path(conn, :create), land: invalid_params
      assert html_response(conn, 200) =~ ~S(action="/lands)
    end
  end

  describe "edit land" do
    setup [:create_land]

    @tag :logged_in
    test "renders form for editing chosen land", %{conn: conn, land: land} do
      conn = get conn, land_path(conn, :edit, land)
      assert html_response(conn, 200) =~ ~S(action="/lands)
    end
  end

  describe "update land" do
    setup [:create_land]

    @tag :logged_in
    test "redirects when data is valid", %{conn: conn, land: land} do
      surface = 123
      land_params = params_for(:land, surface: surface)
      conn1 = put conn, land_path(conn, :update, land), land: land_params 
      assert redirected_to(conn1) == land_path(conn, :show, land)

      conn2 = get conn, land_path(conn, :show, land)
      assert html_response(conn2, 200) =~ surface |> Integer.to_string
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn, land: land} do
      land_params = params_for(:land, surface: "astring")
      conn = put conn, land_path(conn, :update, land), land: land_params 
      assert html_response(conn, 200) =~ ~S(action="/lands)
    end
  end

  describe "delete land" do
    setup [:create_land]

    @tag :logged_in
    test "deletes chosen land", %{conn: conn, land: land} do
      conn1 = delete conn, land_path(conn, :delete, land)
      assert redirected_to(conn1) == land_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, land_path(conn, :show, land)
      end
    end
  end

  defp create_land(_) do
    land = insert(:land)
    {:ok, land: land}
  end
end
