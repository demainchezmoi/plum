defmodule Plum.GeoTest do
  use Plum.DataCase

  import Plum.Factory
  alias Plum.Geo
  alias Plum.Geo.{
    Land,
  }

  describe "lands" do
    test "list_lands/0 returns all lands" do
      land = insert(:land)
      assert Geo.list_lands() |> Enum.map(& &1.id) == [land.id]
    end

    test "get_land!/1 returns the land with given id" do
      land = insert(:land)
      assert Geo.get_land!(land.id).id == land.id
    end

    test "get_land_by!/2 returns the land with given id" do
      land = insert(:land)
      assert Geo.get_land_by!(%{id: land.id}).id == land.id
    end

    test "create_land/1 with valid data creates a land" do
      land_params = params_for(:land)
      assert {:ok, p = %Land{}} = Geo.create_land(land_params)
    end

    test "create_land/1 with invalid data returns error changeset" do
      land_params = params_for(:land) |> Map.put(:max_budget, "abc")
      assert {:error, %Ecto.Changeset{}} = Geo.create_land(land_params)
    end

    test "update_land/2 with valid data updates the land" do
      land_params = params_for(:land)
      land = insert(:land, land_params)
      land_params_updated = land_params |> Map.put(:surface, 1_000)
      assert {:ok, land} = Geo.update_land(land, land_params_updated)
      assert %Land{} = land
      assert land.surface == land_params_updated.surface
    end

    test "update_land/2 with invalid data returns error changeset" do
      land_params = params_for(:land)
      land = insert(:land)
      land_params_updated = land_params |> Map.put(:surface, "abc")
      assert {:error, %Ecto.Changeset{}} = Geo.update_land(land, land_params_updated)
      assert land.surface == Geo.get_land!(land.id).surface
    end

    test "delete_land/1 deletes the land" do
      land = insert(:land)
      assert {:ok, %Land{}} = Geo.delete_land(land)
      assert_raise Ecto.NoResultsError, fn -> Geo.get_land!(land.id) end
    end

    test "change_land/1 returns a land changeset" do
      land = insert(:land)
      assert %Ecto.Changeset{} = Geo.change_land(land)
    end
  end
end

