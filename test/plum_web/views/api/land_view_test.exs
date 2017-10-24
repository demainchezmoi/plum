defmodule PlumWeb.Api.LandViewTest do
  use PlumWeb.ConnCase
  alias PlumWeb.Api.LandView
  import Plum.Factory

  describe "index.json" do
    test "renders list of land.json" do
      lands = insert_list(1, :land)
      expected = %{data: lands |> Enum.map(&LandView.render("land.json", %{land: &1}))}
      rendered = LandView.render "index.json", %{lands: lands}
      assert rendered == expected
    end
  end

  describe "land.json" do
    test "renders a land" do
      land = insert(:land)
      rendered = LandView.render "land.json", %{land: land}
      assert rendered
      assert rendered.location.lat == land.location.lat
      assert rendered.location.lng == land.location.lng
    end
  end
end
