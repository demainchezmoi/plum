defmodule PlumWeb.Api.LandControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias Plum.Geo

  describe "index" do
    setup [:create_land]

    @tag :logged_in
    test "lists all lands", %{conn: conn} do
      conn = get conn, api_land_path(conn, :index)
      assert json_response(conn, 200)
    end

    test "doesn't list all lands when not logged in", %{conn: conn} do
      conn = get conn, api_land_path(conn, :index)
      assert json_response(conn, 401)
    end

    @tag :logged_in
    test "get prospect lands whith given status", %{conn: conn} do
      prospect = insert(:prospect)
      land = insert :land, city: build(:city)
      params = [land_id: land.id, prospect_id: prospect.id, status: "test"]
      insert :prospect_land, params

      query_params = %{"prospect" => prospect.id, "pl_status" => "test"}
      conn = get conn, api_land_path(conn, :index, query_params)
      ids = json_response(conn, 200) |> Map.get("data") |> Enum.map(& &1["id"])
      assert land.id in ids
    end

    @tag :logged_in
    test "get prospectlands without association", %{conn: conn} do
      prospect = insert(:prospect)
      land = insert :land, city: build(:city)
      query_params = %{"prospect" => prospect.id}
      conn = get conn, api_land_path(conn, :index, query_params)
      ids = json_response(conn, 200) |> Map.get("data") |> Enum.map(& &1["id"])
      assert land.id in ids
    end

    @tag :logged_in
    test "reject prospect lands with associations", %{conn: conn} do
      prospect = insert(:prospect)
      land = insert :land, city: build(:city)
      params = [land_id: land.id, prospect_id: prospect.id, status: "test"]
      insert :prospect_land, params
      query_params = %{"prospect" => prospect.id}
      conn = get conn, api_land_path(conn, :index, query_params)
      ids = json_response(conn, 200) |> Map.get("data") |> Enum.map(& &1["id"])
      refute land.id in ids
    end
  end


  describe "show land" do
    setup [:create_land]

    @tag :logged_in
    test "shows a land", %{conn: conn, land: land} do
      conn = get conn, api_land_path(conn, :show, land)
      assert json_response(conn, 200)["data"]["id"] == land.id
    end
  end

  describe "create land" do
    test "doesn't create land if not logged in", %{conn: conn} do
      land_attrs = params_for(:land)
      conn1 = post conn, api_land_path(conn, :create), land: land_attrs 
      assert json_response(conn1, 401)
      query_params = land_attrs |> Map.take([:surface])
      assert_raise Ecto.NoResultsError, fn -> Geo.get_land_by!(query_params) end
    end

    @tag :logged_in
    test "renders land when data is valid", %{conn: conn} do
      land_attrs = params_for(:land)
      conn1 = post conn, api_land_path(conn, :create), land: land_attrs 
      assert %{"id" => id} = json_response(conn1, 201) |> Map.get("data")

      conn2 = get conn, api_land_path(conn, :show, id)
      assert %{"id" => ^id} = json_response(conn2, 200)["data"]
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      land_attrs = params_for(:land) |> Map.put(:surface, "string")
      conn = post conn, api_land_path(conn, :create), land: land_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete land" do
    setup [:create_land]

    @tag :logged_in
    test "deletes land", %{conn: conn, land: land} do
      conn = delete conn, api_land_path(conn, :delete, land)
      assert json_response(conn, 200)
      assert_raise Ecto.NoResultsError, fn -> Geo.get_land!(land.id) end
    end

    test "doesnt delete land when not logged in", %{conn: conn, land: land} do
      conn = delete conn, api_land_path(conn, :delete, land)
      assert json_response(conn, 401)
      assert Geo.get_land!(land.id)
    end
  end

  defp create_land(_) do
    land = insert(:land)
    {:ok, land: land}
  end
end
