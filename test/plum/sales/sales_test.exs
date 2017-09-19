defmodule Plum.SalesTest do
  use Plum.DataCase
  alias Plum.Sales
  alias Plum.Sales.{
    Ad,
    Contact,
    Land
  }
  import Plum.Factory

  describe "contact" do

    test "list_contact/0 returns all contact" do
      land = insert(:land)
      [contact|_] = land.ad.contacts
      assert Sales.list_contact() |> Enum.map(& &1.id) == [contact.id]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = insert(:contact)
      assert Sales.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      land = insert(:land)
      contact_params = params_for(:contact) |> Map.put(:ad_id, land.ad.id)
      assert {:ok, %Contact{}} = Sales.create_contact(contact_params)
    end

    test "create_contact/1 with invalid data returns error changeset" do
      land = insert(:land)
      contact_params = params_for(:contact) |> Map.put(:ad_id, land.ad.id) |> Map.delete(:phone)
      assert {:error, %Ecto.Changeset{}} = Sales.create_contact(contact_params)
    end

    test "update_contact/2 with valid data updates the contact" do
      new_email = "coucou@lol.changed"
      land = insert(:land)
      [contact|_] = land.ad.contacts
      contact_params = params_for(:contact) |> Map.put(:ad_id, land.ad.id) |> Map.put(:email, new_email)
      assert {:ok, contact} = Sales.update_contact(contact, contact_params)
      assert %Contact{} = contact
      assert contact.email == new_email 
    end

    test "update_contact/2 with invalid data returns error changeset" do
      land = insert(:land)
      [contact|_] = land.ad.contacts
      contact_params = params_for(:contact) |> Map.put(:ad_id, land.ad.id) |> Map.put(:email, nil)
      assert {:error, %Ecto.Changeset{}} = Sales.update_contact(contact, contact_params)
      assert contact == Sales.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      land = insert(:land)
      [contact|_] = land.ad.contacts
      assert {:ok, %Contact{}} = Sales.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      land = insert(:land)
      [contact|_] = land.ad.contacts
      assert %Ecto.Changeset{} = Sales.change_contact(contact)
    end
  end

  describe "ad" do

    test "list_ad/0 returns all ad" do
      land = insert(:land)
      assert Sales.list_ad() |> Enum.map(& &1.id) == [land.ad.id]
    end

    test "get_ad!/1 returns the ad with given id" do
      land = insert(:land)
      assert Sales.get_ad!(land.ad.id).id == land.ad.id
    end

    test "get_ad_where!/2 returns the ad with given id" do
      land = insert(:land)
      ad = insert(:ad, land_id: land.id, active: false)
      assert Sales.get_ad_where!(ad.id, %{active: false}).id == ad.id
    end

    test "get_ad_where!/2 raises when ad doesn't match" do
      land = insert(:land)
      ad = insert(:ad, land_id: land.id, active: false)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad_where!(ad.id, %{active: true}) end
    end

    test "create_ad/1 with valid data creates a ad" do
      land = insert(:land)
      ad_params = params_for(:ad) |> Map.put(:land_id, land.id)
      assert {:ok, %Ad{} = ad} = Sales.create_ad(ad_params)
      assert ad.land_id == land.id
    end

    test "create_ad/1 with invalid data returns error changeset" do
      insert(:land)
      ad_params = params_for(:ad) # missing land_id
      assert {:error, %Ecto.Changeset{}} = Sales.create_ad(ad_params)
    end

    test "update_ad/2 with valid data updates the ad" do
      land = insert(:land)
      ad = land.ad
      ad_params = params_for(:ad) |> Map.put(:land_id, land.id) |> Map.put(:active, false)
      assert {:ok, ad} = Sales.update_ad(ad, ad_params)
      assert %Ad{} = ad
      assert ad.active == false 
    end

    test "update_ad/2 with invalid data returns error changeset" do
      land = insert(:land)
      ad = land.ad
      ad_params = params_for(:ad) |> Map.put(:active, "astring") 
      assert {:error, %Ecto.Changeset{}} = Sales.update_ad(ad, ad_params)
      assert ad.active == Sales.get_ad!(ad.id).active
    end

    test "delete_ad/1 deletes the ad" do
      land = insert(:land)
      assert {:ok, %Ad{}} = Sales.delete_ad(land.ad)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad!(land.ad.id) end
    end

    test "change_ad/1 returns a ad changeset" do
      land = insert(:land)
      assert %Ecto.Changeset{} = Sales.change_ad(land.ad)
    end
  end

  describe "lands" do

    test "list_lands/0 returns all lands" do
      land = insert(:land)
      assert Sales.list_lands() |> Enum.map(& &1.id) == [land.id]
    end

    test "get_land!/1 returns the land with given id" do
      land = insert(:land)
      assert Sales.get_land!(land.id).id == land.id
    end

    test "create_land/1 with valid data creates a land" do
      land_params = params_for(:land)
      assert {:ok, %Land{}} = Sales.create_land(land_params)
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
