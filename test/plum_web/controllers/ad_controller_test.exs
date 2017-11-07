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

  defp create_ad(_) do
    land = insert(:land)
    ad = land.ads |> List.first
    {:ok, ad: ad, land: land}
  end
end
