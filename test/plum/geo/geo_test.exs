defmodule Plum.GeoTest do
  use Plum.DataCase

  import Plum.Factory
  alias Plum.Geo
  alias Plum.Geo.{
    Land,
  }
  alias Plum.Sales.{
    ProspectLand
  }

  describe "cities" do
    setup [:create_city]

    test "cities_autocomplete finds city by uppercase name", %{city: city} do
      assert city.id in (Geo.cities_autocomplete("BLA") |> Enum.map(& &1.id))
    end

    test "cities_autocomplete finds city by downcase name", %{city: city} do
      assert city.id in (Geo.cities_autocomplete("bla") |> Enum.map(& &1.id))
    end

    test "cities_autocomplete finds city by string in middle of name", %{city: city} do
      assert city.id in (Geo.cities_autocomplete("laru") |> Enum.map(& &1.id))
    end

    test "cities_autocomplete finds city by department", %{city: city} do
      assert city.id in (Geo.cities_autocomplete("123") |> Enum.map(& &1.id))
    end

    test "cities_autocomplete rejetc unmatching cities", %{city: city} do
      refute city.id in (Geo.cities_autocomplete("678 Man") |> Enum.map(& &1.id))
    end
  end

  describe "lands" do
    test "list_lands/0 returns all lands with cities" do
      land = insert(:land, city: build(:city))
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
      city = insert(:city)
      land_params = params_for(:land, city_id: city.id)
      assert {:ok, %Land{}} = Geo.create_land(land_params)
    end

    test "create_land/1 associates prospects from prospects_lands" do
      city = insert(:city)
      prospect = insert(:prospect)
      prospect_id = prospect.id
      prospect_land = params_for(:prospect_land, prospect: prospect, status: "test")
      land_params = params_for(:land, city_id: city.id) |> Map.put(:prospects_lands, [prospect_land])
      assert {:ok, %Land{id: land_id}} = Geo.create_land(land_params)
      assert %ProspectLand{status: "test"} = ProspectLand |> Repo.get_by(%{prospect_id: prospect_id, land_id: land_id})
    end

    test "create_land/1 associates city" do
      city = insert(:city)
      city_id = city.id
      land_params = params_for(:land) |> Map.put(:city_id, city.id)
      assert {:ok, %Land{city_id: ^city_id}} = Geo.create_land(land_params)
    end

    test "create_land/1 with invalid data returns error changeset" do
      land_params = params_for(:land) |> Map.put(:surface, "abc")
      assert {:error, %Ecto.Changeset{}} = Geo.create_land(land_params)
    end

    test "update_land/2 with valid data updates the land" do
      city = insert(:city)
      land_params = params_for(:land, city_id: city.id)
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

  defp create_city(_) do
    city = insert(:city, name: "Blaru", postal_code: "1234")
    {:ok, city: city}
  end
end
