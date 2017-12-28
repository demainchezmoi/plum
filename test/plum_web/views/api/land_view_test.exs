defmodule PlumWeb.Api.LandViewTest do
  use Plum.DataCase, async: true

  alias PlumWeb.Api.{LandView}

  import Plum.Factory

  test "land.json" do
    land = build(:land)
    rendered = LandView.render("land.json", %{land: land})
    assert rendered.id == land.id
  end
end

