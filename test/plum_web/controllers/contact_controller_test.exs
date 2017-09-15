defmodule PlumWeb.ContactControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  alias Plum.Sales

  describe "index" do
    test "lists all contact", %{conn: conn} do
      conn = get conn, contact_path(conn, :index)
      assert html_response(conn, 200)
    end
  end

  describe "new contact" do
    test "renders form", %{conn: conn} do
      land = insert(:land)
      conn = get conn, contact_path(conn, :new, %{"ad" => land.ad.id})
      assert html_response(conn, 200) =~ ~S(action="/contact)
    end
  end

  describe "create contact" do
    test "redirects to show when data is valid", %{conn: conn} do
      land = insert(:land)
      contact_params = params_for(:contact, ad_id: land.ad.id)
      conn = post conn, contact_path(conn, :create), contact: contact_params 

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == contact_path(conn, :show, id)

      conn = get conn, contact_path(conn, :show, id)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      land = insert(:land)
      contact_params = params_for(:contact, ad_id: land.ad.id) |> Map.put(:phone, 123)
      conn = post conn, contact_path(conn, :create), contact: contact_params 
      assert html_response(conn, 200) =~ ~S(action="/contact)
    end
  end

  describe "edit contact" do
    setup [:create_contact]

    test "renders form for editing chosen contact", %{conn: conn, contact: contact} do
      conn = get conn, contact_path(conn, :edit, contact)
      assert html_response(conn, 200) =~ ~S(action="/contact)
    end
  end

  describe "update contact" do
    setup [:create_contact]

    test "redirects when data is valid", %{conn: conn, contact: contact, land: land} do
      contact_params = params_for(:contact, ad_id: land.ad.id) |> Map.put(:active, false)
      conn = put conn, contact_path(conn, :update, contact), contact: contact_params 
      assert redirected_to(conn) == contact_path(conn, :show, contact)

      conn = get conn, contact_path(conn, :show, contact)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact, land: land} do
      contact_params = params_for(:contact, ad_id: land.ad.id) |> Map.put(:phone, 1234)
      conn = put conn, contact_path(conn, :update, contact), contact: contact_params 
      assert html_response(conn, 200) =~ ~S(action="/contact)
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn = delete conn, contact_path(conn, :delete, contact)
      assert redirected_to(conn) == contact_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, contact_path(conn, :show, contact)
      end
    end
  end

  defp create_contact(_) do
    land = insert(:land)
    ad = land.ad
    [contact|_] = ad.contacts
    {:ok, contact: contact, land: land, ad: ad}
  end
end

