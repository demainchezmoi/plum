defmodule PlumWeb.AdControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory

  describe "index" do
    @tag :logged_in
    test "lists all ad", %{conn: conn} do
      conn = get conn, ad_path(conn, :index)
      assert html_response(conn, 200)
    end
  end

  describe "new ad" do
    @tag :logged_in
    test "renders form", %{conn: conn} do
      conn = get conn, ad_path(conn, :new)
      assert html_response(conn, 200)
    end
  end

  describe "show ad" do
    setup [:create_ad]

    @tag :logged_in
    test "renders show", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :show, ad)
      assert html_response(conn, 200)
    end

    test "doesnt render show when not logged in", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :show, ad)
      assert html_response(conn, 302)
    end
  end

  describe "public ad" do
    setup [:create_ad]

    test "shows add", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :public, ad)
      assert html_response(conn, 200)
    end

    test "doesn't show deactivated add", %{conn: conn, ad: ad} do
      Plum.Sales.update_ad(ad, %{active: false})
      assert_error_sent 404, fn ->
        get conn, ad_path(conn, :public, ad)
      end
    end
  end

  describe "create ad" do
    @tag :logged_in
    test "redirects to show when data is valid", %{conn: conn} do
      land = insert(:land)
      ad_params = params_for(:ad, land_id: land.id)
      conn1 = post conn, ad_path(conn, :create), ad: ad_params 

      assert %{id: id} = redirected_params(conn1)
      assert redirected_to(conn1) == ad_path(conn, :show, id)

      conn2 = get conn, ad_path(conn, :show, id)
      assert html_response(conn2, 200)
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn} do
      land = insert(:land)
      ad_params = params_for(:ad, land_id: land.id) |> Map.put(:active, "astring")
      conn = post conn, ad_path(conn, :create), ad: ad_params 
      assert html_response(conn, 200) =~ ~S(action="/ad)
    end
  end

  describe "edit ad" do
    setup [:create_ad]

    @tag :logged_in
    test "renders form for editing chosen ad", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :edit, ad)
      assert html_response(conn, 200) =~ ~S(action="/ad)
    end
  end

  describe "update ad" do
    setup [:create_ad]

    @tag :logged_in
    test "redirects when data is valid", %{conn: conn, ad: ad, land: land} do
      ad_params = params_for(:ad, land_id: land.id) |> Map.put(:active, false)
      conn1 = put conn, ad_path(conn, :update, ad), ad: ad_params 
      assert redirected_to(conn1) == ad_path(conn, :show, ad)

      conn2 = get conn, ad_path(conn, :show, ad)
      assert html_response(conn2, 200)
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn, ad: ad, land: land} do
      ad_params = params_for(:ad, land_id: land.id) |> Map.put(:active, "astring")
      conn = put conn, ad_path(conn, :update, ad), ad: ad_params 
      assert html_response(conn, 200) =~ ~S(action="/ad)
    end
  end

  describe "delete ad" do
    setup [:create_ad]

    @tag :logged_in
    test "deletes chosen ad", %{conn: conn, ad: ad} do
      conn1 = delete conn, ad_path(conn, :delete, ad)
      assert redirected_to(conn1) == ad_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, ad_path(conn, :show, ad)
      end
    end
  end

  defp create_ad(_) do
    land = insert(:land)
    ad = land.ad
    {:ok, ad: ad, land: land}
  end
end
