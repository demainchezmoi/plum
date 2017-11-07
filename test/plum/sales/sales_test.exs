defmodule Plum.SalesTest do
  use Plum.DataCase
  alias Plum.Sales
  alias Plum.Sales.{
    Ad,
    Land,
  }
  import Plum.Factory

  describe "ad" do
    test "list_ads/0 returns all ad" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert Sales.list_ads() |> Enum.map(& &1.id) == [ad.id]
    end

    test "get_ad!/1 returns the ad with given id" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert Sales.get_ad!(ad.id)
    end

    test "get_ad_by!/2 returns the ad with given id" do
      land = insert(:land)
      ad = insert(:ad, land_id: land.id, active: false)
      assert Sales.get_ad_by!(%{id: ad.id, active: false}).id == ad.id
    end

    test "get_ad_by!/2 raises when ad doesn't match" do
      land = insert(:land)
      ad = insert(:ad, land_id: land.id, active: false)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad_by!(%{id: ad.id, active: true}) end
    end

    test "create_ad/1 with valid data creates a ad" do
      land = insert(:land)
      ad_params = params_for(:ad) |> Map.put(:land_id, land.id)
      assert {:ok, %Ad{} = ad} = Sales.create_ad(ad_params)
      assert ad.land_id == land.id
    end

    test "create_ad/1 with invalid data returns error changeset" do
      insert(:land)
      ad_params = params_for(:ad) |> Map.put(:active, "string")
      assert {:error, %Ecto.Changeset{}} = Sales.create_ad(ad_params)
    end

    test "update_ad/2 with valid data updates the ad" do
      land = insert(:land)
      ad = land.ads |> List.first
      ad_params = params_for(:ad) |> Map.put(:land_id, land.id) |> Map.put(:active, false)
      assert {:ok, ad} = Sales.update_ad(ad, ad_params)
      assert %Ad{} = ad
      assert ad.active == false 
    end

    test "update_ad/2 with invalid data returns error changeset" do
      land = insert(:land)
      ad = land.ads |> List.first
      ad_params = params_for(:ad) |> Map.put(:active, "astring") 
      assert {:error, %Ecto.Changeset{}} = Sales.update_ad(ad, ad_params)
      assert ad.active == Sales.get_ad!(ad.id).active
    end

    test "delete_ad/1 deletes the ad" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert {:ok, %Ad{}} = Sales.delete_ad(ad)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad!(ad.id) end
    end

    test "change_ad/1 returns a ad changeset" do
      land = insert(:land)
      ad = land.ads |> List.first
      assert %Ecto.Changeset{} = Sales.change_ad(ad)
    end
  end

  describe "lands" do
    test "list_lands/0 returns all lands" do
      land = insert(:land)
      assert Sales.list_lands() |> Enum.map(& &1.id) == [land.id]
    end

    test "list_lands/0 preload ads" do
      insert(:land)
      assert Sales.list_lands() |> List.first |> Map.get(:ads) |> length > 0 
    end

    test "get_land!/1 returns the land with given id" do
      land = insert(:land)
      assert Sales.get_land!(land.id).id == land.id
    end

    test "get_land!/1 preloads the ads" do
      land = insert(:land)
      assert length(Sales.get_land!(land.id).ads) > 0 
    end

    test "get_land_by!/2 returns the land with given id" do
      land = insert(:land)
      assert Sales.get_land_by!(%{id: land.id}).id == land.id
    end

    test "get_land_by!/2 preloads the ads" do
      land = insert(:land)
      assert length(Sales.get_land_by!(%{id: land.id}).ads) > 0 
    end

    test "get_land_by!/2 raises when ad doesn't match" do
      land = insert(:land)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_land_by!(%{id: land.id, surface: -1}) end
    end

    test "create_land/1 with valid data creates a land" do
      land_params = params_for(:land)
      assert {:ok, %Land{description: _, images: _}} = Sales.create_land(land_params)
    end

    test "create_land/1 with valid data creates associated ads" do
      land_params = params_for(:land)
      assert {:ok, %Land{description: _, images: _, ads: ads, id: id}} = Sales.create_land(land_params)
      assert ads |> List.first |> Map.get(:land_id) == id
    end

    test "create_land/1 sets notary_fees" do
      land_params = params_for(:land) |> Map.delete(:notary_fees)
      assert {:ok, land} = Sales.create_land(land_params)
      assert land.notary_fees == Plum.Helpers.NotaryFees.notary_fees(land_params.price)
    end

    test "create_land/1 with invalid data returns error changeset" do
      land_params = params_for(:land) |> Map.delete(:price)
      assert {:error, %Ecto.Changeset{}} = Sales.create_land(land_params)
    end

    test "update_land/2 with valid data updates the land" do
      land_params = params_for(:land)
      land = insert(:land, land_params)
      land_params_updated = land_params |> Map.put(:surface, 10_000)
      assert {:ok, land} = Sales.update_land(land, land_params_updated)
      assert %Land{} = land
      assert land.surface == land_params_updated.surface
    end

    test "update_land/2 with invalid data returns error changeset" do
      land_params = params_for(:land)
      land = insert(:land)
      land_params_updated = land_params |> Map.put(:surface, nil)
      assert {:error, %Ecto.Changeset{}} = Sales.update_land(land, land_params_updated)
      assert land.surface == Sales.get_land!(land.id).surface
    end

    test "delete_land/1 deletes the land" do
      land = insert(:land)
      assert {:ok, %Land{}} = Sales.delete_land(land)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_land!(land.id) end
    end

    test "change_land/1 returns a land changeset" do
      land = insert(:land)
      assert %Ecto.Changeset{} = Sales.change_land(land)
    end
  end
end
