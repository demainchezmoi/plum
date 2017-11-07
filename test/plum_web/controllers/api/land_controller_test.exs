defmodule PlumWeb.Api.LandControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias Plum.Sales

  describe "index" do
    setup [:create_land]

    @tag logged_in: ["admin"]
    test "lists all lands when admin in", %{conn: conn, token: token} do
      conn = get conn, api_land_path(conn, :index), token: token
      assert json_response(conn, 200)
    end

    @tag logged_in: ["admin"]
    test "preload ads", %{conn: conn, token: token} do
      conn = get conn, api_land_path(conn, :index), token: token
      assert not is_nil(json_response(conn, 200)["data"] |> List.first |> Map.get("ads"))
    end

    @tag :logged_in
    test "doesn't list all lands when not admin", %{conn: conn} do
      conn = get conn, api_land_path(conn, :index)
      assert json_response(conn, 403)
    end

    test "doesn't list all lands when not logged in", %{conn: conn} do
      conn = get conn, api_land_path(conn, :index)
      assert json_response(conn, 401)
    end
  end


  describe "show land" do
    @tag :logged_in
    test "doesn't show a land if not admin", %{conn: conn} do
      land = insert(:land)
      conn = get conn, api_land_path(conn, :show, land)
      assert json_response(conn, 403)
    end

    @tag logged_in: ["admin"]
    test "shows a land", %{conn: conn} do
      land = insert(:land)
      conn = get conn, api_land_path(conn, :show, land)
      assert json_response(conn, 200)["data"]["id"] == land.id
    end

    @tag logged_in: ["admin"]
    test "preloads the ads", %{conn: conn} do
      land = insert(:land)
      conn = get conn, api_land_path(conn, :show, land)
      assert json_response(conn, 200)["data"]["ads"] |> length > 0
    end
  end


  describe "create land" do
    test "doesn't create land if not logged in", %{conn: conn} do
      land_attrs = params_for(:land)
      conn1 = post conn, api_land_path(conn, :create), land: land_attrs 
      assert json_response(conn1, 401)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_land_by!(land_attrs |> Map.drop([:ads, :location])) end
    end

    @tag :logged_in
    test "doesn't create land if not admin", %{conn: conn} do
      land_attrs = params_for(:land) 
      conn1 = post conn, api_land_path(conn, :create), land: land_attrs 
      assert json_response(conn1, 403)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_land_by!(land_attrs |> Map.drop([:ads, :location])) end
    end

    @tag logged_in: ["admin"]
    test "renders land when data is valid", %{conn: conn} do
      land_attrs = params_for(:land)
      conn1 = post conn, api_land_path(conn, :create), land: land_attrs 
      assert %{"id" => id} = json_response(conn1, 201)["data"]

      conn2 = get conn, api_land_path(conn, :show, id)
      assert %{"id" => ^id} = json_response(conn2, 200)["data"]
    end

    @tag logged_in: ["admin"]
    test "creates associated ads", %{conn: conn} do
      land_attrs = params_for(:land)
      conn1 = post conn, api_land_path(conn, :create), land: land_attrs 
      assert %{"ads" => ads} = json_response(conn1, 201)["data"]
      assert length(ads) > 0
    end

    @tag logged_in: ["admin"]
    test "renders errors when data is invalid", %{conn: conn} do
      land_attrs = params_for(:land) |> Map.delete(:surface)
      conn = post conn, api_land_path(conn, :create), land: land_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update land" do
    setup [:create_land]

    @tag logged_in: ["admin"]
    test "updates land with valid data", %{conn: conn, land: land} do
      land_attrs = %{"surface" => 2}
      conn = put conn, api_land_path(conn, :update, land), land: land_attrs
      assert %{"data" => %{"surface" => 2}} = json_response(conn, 200) 
    end

    @tag logged_in: ["admin"]
    test "sends error with invalid data", %{conn: conn, land: land} do
      land_attrs = %{"surface" => nil}
      conn = put conn, api_land_path(conn, :update, land), land: land_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete land" do
    setup [:create_land]

    @tag logged_in: ["admin"]
    test "deletes chosen land", %{conn: conn, land: land} do
      conn1 = delete conn, api_land_path(conn, :delete, land)
      assert json_response(conn1, 200)
      assert_error_sent 404, fn ->
        get conn, api_land_path(conn, :show, land)
      end
    end
  end

  defp create_land(_) do
    land = insert(:land)
    {:ok, land: land}
  end
end
