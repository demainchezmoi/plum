defmodule PlumWeb.Api.AdControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias Plum.Sales

  describe "index" do
    setup [:create_ad]

    @tag logged_in: ["admin"]
    test "lists all ads when admin in", %{conn: conn, token: token} do
      conn = get conn, api_ad_path(conn, :index), token: token
      assert json_response(conn, 200)
    end

    @tag :logged_in
    test "doesn't list all ads when not admin", %{conn: conn} do
      conn = get conn, api_ad_path(conn, :index)
      assert json_response(conn, 403)
    end

    test "doesn't list all ads when not logged in", %{conn: conn} do
      conn = get conn, api_ad_path(conn, :index)
      assert json_response(conn, 401)
    end
  end


  describe "show ad" do
    @tag :logged_in
    test "doesn't show a ad if not admin", %{conn: conn} do
      ad = insert(:ad)
      conn = get conn, api_ad_path(conn, :show, ad)
      assert json_response(conn, 403)
    end

    @tag logged_in: ["admin"]
    test "shows a ad", %{conn: conn} do
      ad = insert(:ad)
      conn = get conn, api_ad_path(conn, :show, ad)
      assert json_response(conn, 200)["data"]["id"] == ad.id
    end
  end

  describe "create ad" do
    test "doesn't create ad if not logged in", %{conn: conn} do
      ad_attrs = params_for(:ad)
      conn1 = post conn, api_ad_path(conn, :create), ad: ad_attrs 
      assert json_response(conn1, 401)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad_by!(ad_attrs) end
    end

    @tag :logged_in
    test "doesn't create ad if not admin", %{conn: conn} do
      ad_attrs = params_for(:ad) 
      conn1 = post conn, api_ad_path(conn, :create), ad: ad_attrs 
      assert json_response(conn1, 403)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad_by!(ad_attrs) end
    end

    @tag logged_in: ["admin"]
    test "renders ad when data is valid", %{conn: conn} do
      land = insert(:land)
      ad_attrs = params_for(:ad, land_id: land.id)
      conn1 = post conn, api_ad_path(conn, :create), ad: ad_attrs 
      assert %{"id" => id} = json_response(conn1, 201)["data"]

      conn2 = get conn, api_ad_path(conn, :show, id)
      assert %{"id" => ^id} = json_response(conn2, 200)["data"]
    end

    @tag logged_in: ["admin"]
    test "renders errors when data is invalid", %{conn: conn} do
      ad_attrs = params_for(:ad) |> Map.put(:active, "string")
      conn = post conn, api_ad_path(conn, :create), ad: ad_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_ad(_) do
    ad = insert(:ad)
    {:ok, ad: ad}
  end
end

