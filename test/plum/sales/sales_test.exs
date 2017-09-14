defmodule Plum.SalesTest do
  use Plum.DataCase

  alias Plum.Sales

  describe "contact" do
    alias Plum.Sales.Contact

    @valid_attrs %{email: "some email", name: "some name", phone: "some phone"}
    @update_attrs %{email: "some updated email", name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{email: nil, name: nil, phone: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sales.create_contact()

      contact
    end

    test "list_contact/0 returns all contact" do
      contact = contact_fixture()
      assert Sales.list_contact() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Sales.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Sales.create_contact(@valid_attrs)
      assert contact.email == "some email"
      assert contact.name == "some name"
      assert contact.phone == "some phone"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, contact} = Sales.update_contact(contact, @update_attrs)
      assert %Contact{} = contact
      assert contact.email == "some updated email"
      assert contact.name == "some updated name"
      assert contact.phone == "some updated phone"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_contact(contact, @invalid_attrs)
      assert contact == Sales.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Sales.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Sales.change_contact(contact)
    end
  end

  describe "ad" do
    alias Plum.Sales.Ad

    @valid_attrs %{land_lat: 120.5, land_lng: 120.5, land_price: 42, land_surface: 42}
    @update_attrs %{land_lat: 456.7, land_lng: 456.7, land_price: 43, land_surface: 43}
    @invalid_attrs %{land_lat: nil, land_lng: nil, land_price: nil, land_surface: nil}

    def ad_fixture(attrs \\ %{}) do
      {:ok, ad} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sales.create_ad()

      ad
    end

    test "list_ad/0 returns all ad" do
      ad = ad_fixture()
      assert Sales.list_ad() == [ad]
    end

    test "get_ad!/1 returns the ad with given id" do
      ad = ad_fixture()
      assert Sales.get_ad!(ad.id) == ad
    end

    test "create_ad/1 with valid data creates a ad" do
      assert {:ok, %Ad{} = ad} = Sales.create_ad(@valid_attrs)
      assert ad.land_lat == 120.5
      assert ad.land_lng == 120.5
      assert ad.land_price == 42
      assert ad.land_surface == 42
    end

    test "create_ad/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_ad(@invalid_attrs)
    end

    test "update_ad/2 with valid data updates the ad" do
      ad = ad_fixture()
      assert {:ok, ad} = Sales.update_ad(ad, @update_attrs)
      assert %Ad{} = ad
      assert ad.land_lat == 456.7
      assert ad.land_lng == 456.7
      assert ad.land_price == 43
      assert ad.land_surface == 43
    end

    test "update_ad/2 with invalid data returns error changeset" do
      ad = ad_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_ad(ad, @invalid_attrs)
      assert ad == Sales.get_ad!(ad.id)
    end

    test "delete_ad/1 deletes the ad" do
      ad = ad_fixture()
      assert {:ok, %Ad{}} = Sales.delete_ad(ad)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_ad!(ad.id) end
    end

    test "change_ad/1 returns a ad changeset" do
      ad = ad_fixture()
      assert %Ecto.Changeset{} = Sales.change_ad(ad)
    end
  end
end
