defmodule PlumWeb.Api.LandViewTest do
  use PlumWeb.ConnCase, async: true
  alias PlumWeb.Api.LandView
  import Plum.Factory

  describe "index.json" do
    test "renders list of land.json" do
      lands = insert_list(1, :land)
      expected = lands |> Enum.map(&LandView.render("land.json", %{land: &1}))
      rendered = LandView.render "index.json", %{lands: lands}
      assert rendered == expected
    end
  end

  describe "land.json" do
    land = build(:land)
    assert LandView.render "land.json", %{land: land}
  end
end
