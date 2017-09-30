defmodule PlumWeb.ContactControllerTest do
  use PlumWeb.ConnCase
  import Plum.Factory
  import Swoosh.TestAssertions
  alias Plum.Repo
  alias Plum.Sales.Contact

  describe "index" do
    @tag :logged_in
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
    test "redirects to :merci when data is valid", %{conn: conn} do
      land = insert(:land)
      contact_params = params_for(:contact, ad_id: land.ad.id)
      conn = post conn, contact_path(conn, :create), contact: contact_params 
      assert redirected_to(conn) == page_path(conn, :merci)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      land = insert(:land)
      contact_params = params_for(:contact, ad_id: land.ad.id) |> Map.put(:phone, 123)
      conn = post conn, contact_path(conn, :create), contact: contact_params 
      assert html_response(conn, 200) =~ ~S(action="/contact)
    end

    test "sends an email", %{conn: conn} do
      phone = "19471-="
      land = insert(:land)
      contact_params = params_for(:contact, ad_id: land.ad.id, phone: phone)
      post conn, contact_path(conn, :create), contact: contact_params 
      contact = Contact |> Repo.get_by!(%{phone: phone}) |> Repo.preload([ad: :land])
      email = PlumWeb.Email.new_contact(contact)
      assert_email_sent email
    end
  end

  describe "edit contact" do
    setup [:create_contact]

    @tag :logged_in
    test "renders form for editing chosen contact", %{conn: conn, contact: contact} do
      conn = get conn, contact_path(conn, :edit, contact)
      assert html_response(conn, 200) =~ ~S(action="/contact)
    end

    test "doesnt edit contact when not logged in", %{conn: conn, contact: contact} do
      conn = get conn, contact_path(conn, :edit, contact) 
      assert html_response(conn, 302)
    end
  end

  describe "update contact" do
    setup [:create_contact]

    @tag :logged_in
    test "redirects when data is valid", %{conn: conn, contact: contact, land: land} do
      contact_params = params_for(:contact, ad_id: land.ad.id) |> Map.put(:active, false)
      conn1 = put conn, contact_path(conn, :update, contact), contact: contact_params 
      assert redirected_to(conn1) == contact_path(conn, :show, contact)

      conn2 = get conn, contact_path(conn, :show, contact)
      assert html_response(conn2, 200)
    end

    @tag :logged_in
    test "renders errors when data is invalid", %{conn: conn, contact: contact, land: land} do
      contact_params = params_for(:contact, ad_id: land.ad.id) |> Map.put(:phone, 1234)
      conn = put conn, contact_path(conn, :update, contact), contact: contact_params 
      assert html_response(conn, 200) =~ ~S(action="/contact)
    end

    test "doesnt update contact when not logged in", %{conn: conn, contact: contact} do
      conn = get conn, contact_path(conn, :update, contact), contact: %{} 
      assert html_response(conn, 302)
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    @tag :logged_in
    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn1 = delete conn, contact_path(conn, :delete, contact)
      assert redirected_to(conn1) == contact_path(conn, :index)

      assert_error_sent 404, fn ->
        get conn, contact_path(conn, :show, contact)
      end
    end

    test "doesnt delete contact when not logged in", %{conn: conn, contact: contact} do
      conn = get conn, contact_path(conn, :delete, contact)
      assert html_response(conn, 302)
    end
  end

  defp create_contact(_) do
    land = insert(:land)
    ad = land.ad
    [contact|_] = ad.contacts
    {:ok, contact: contact, land: land, ad: ad}
  end
end

