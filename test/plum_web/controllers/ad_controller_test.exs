defmodule PlumWeb.AdControllerTest do
  use PlumWeb.ConnCase

  import Plum.Factory

  describe "public ad" do
    setup [:create_ad]

    test "shows add", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :public, ad)
      assert html_response(conn, 200)
    end

    test "doesn't show deactivated add", %{conn: conn, ad: ad} do
      Plum.Sales.update_ad(ad, %{active: false})
      conn = get conn, ad_path(conn, :public, ad)
      res = html_response(conn, 200)
      assert res |> String.downcase =~ ~S(class="deactivated-ad")
    end
  end

  describe "index" do
    @tag logged_in: ["admin"]
    test "lists all ads", %{conn: conn} do
      conn = get conn, ad_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Ads"
    end
  end

  describe "new ad" do
    @tag logged_in: ["admin"]
    test "renders form", %{conn: conn} do
      conn = get conn, ad_path(conn, :new)
      assert html_response(conn, 200) =~ "New Ad"
    end
  end

  describe "create ad" do
    @tag logged_in: ["admin"]
    test "redirects to show when data is valid", %{conn: conn} do
      land = insert(:land)
      conn1 = post conn, ad_path(conn, :create), ad: params_for(:ad) |> Map.put(:land_id, land.id)

      assert %{id: id} = redirected_params(conn1)
      assert redirected_to(conn1) == ad_path(conn1, :show, id)

      conn2 = get conn, ad_path(conn, :show, id)
      assert html_response(conn2, 200) =~ "Show Ad"
    end

    @tag logged_in: ["admin"]
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, ad_path(conn, :create), ad: params_for(:ad) |> Map.put(:house_price, nil) 
      assert html_response(conn, 200) =~ "New Ad"
    end
  end

  describe "edit ad" do
    setup [:create_ad]

    @tag logged_in: ["admin"]
    test "renders form for editing chosen ad", %{conn: conn, ad: ad} do
      conn = get conn, ad_path(conn, :edit, ad)
      assert html_response(conn, 200) =~ "Edit Ad"
    end
  end

  describe "update ad" do
    setup [:create_ad]

    @tag logged_in: ["admin"]
    test "redirects when data is valid", %{conn: conn, ad: ad} do
      conn1 = put conn, ad_path(conn, :update, ad), ad: params_for(:ad) |> Map.put(:surface, 1)
      assert redirected_to(conn1) == ad_path(conn1, :show, ad)

      conn2 = get conn, ad_path(conn, :show, ad)
      assert html_response(conn2, 200)
    end

    @tag logged_in: ["admin"]
    test "renders errors when data is invalid", %{conn: conn, ad: ad} do
      conn = put conn, ad_path(conn, :update, ad), ad: params_for(:ad) |> Map.put(:house_price, true) 
      assert html_response(conn, 200) =~ "Edit Ad"
    end
  end

  describe "delete ad" do
    setup [:create_ad]

    @tag logged_in: ["admin"]
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
    ad = land.ads |> List.first
    {:ok, ad: ad, land: land}
  end
end
