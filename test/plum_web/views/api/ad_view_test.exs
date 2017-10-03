defmodule PlumWeb.Api.AdViewTest do
  use PlumWeb.ConnCase, async: true

  alias PlumWeb.Api.{
    AdView,
    LandView,
  }

  import Plum.Factory

  test "renders preloaded land" do
    land = insert(:land)
    ad = insert(:ad, land: land)
    rendered = AdView.render "ad.json", %{ad: ad}
    land_view = LandView.render "land.json", %{land: land}
    assert rendered.land == land_view
  end
end
