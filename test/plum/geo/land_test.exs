defmodule Plum.Geo.LandTest do
  use Plum.DataCase
  alias Plum.Geo.Land
  alias Plum.Repo
  import Plum.Factory

  test "land changeset sets location from lng and lat" do
    land_params = params_for(:land) |> Map.put(:lng, 2.32) |> Map.put(:lat, 44.01)
    land = %Land{} |> Land.changeset(land_params) |> Repo.insert!
    assert %Geo.Point{} = land.location
  end

  test "land changeset sets location from address" do
    land_params = params_for(:land) |> Map.put(:address, "address")
    changeset = %Land{} |> Land.changeset(land_params)
    assert %Geo.Point{} = changeset.changes.location
  end
end
