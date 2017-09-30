defmodule PlumWeb.ContactController do
  use PlumWeb, :controller
  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Contact
  alias PlumWeb.Mailer
  alias PlumWeb.Email

  # def index(conn, _params) do
    # contacts = Sales.list_contact() |> Enum.map(& &1 |> Repo.preload(:ad))
    # render(conn, "index.html", contacts: contacts)
  # end

  def new(conn, %{"ad" => ad_id}) do
    ad = Sales.get_ad!(ad_id)
    changeset = Sales.change_contact(%Contact{ad_id: ad.id})
    render(conn, "new.html", changeset: changeset, ad: ad)
  end

  def create(conn, %{"contact" => contact_params}) do
    case Sales.create_contact(contact_params) do
      {:ok, contact} ->
        contact |> Repo.preload([ad: :land]) |> Email.new_contact |> Mailer.deliver
        conn |> redirect(to: page_path(conn, :merci))
      {:error, %Ecto.Changeset{} = changeset} ->
        ad = Sales.get_ad!(contact_params["ad_id"])
        conn
        |> put_flash(:error, "Le formulaire est invalide, merci de corriger les erreurs ci-dessous.")
        |> render("new.html", changeset: changeset, ad: ad)
    end
  end

  # def show(conn, %{"id" => id}) do
    # contact = Sales.get_contact!(id) |> Repo.preload([ad: :land])
    # render(conn, "show.html", contact: contact)
  # end

  # def edit(conn, %{"id" => id}) do
    # contact = Sales.get_contact!(id) |> Repo.preload([ad: :land])
    # changeset = Sales.change_contact(contact)
    # render(conn, "edit.html", contact: contact, changeset: changeset, ad: contact.ad)
  # end

  # def update(conn, %{"id" => id, "contact" => contact_params}) do
    # contact = Sales.get_contact!(id)

    # case Sales.update_contact(contact, contact_params) do
      # {:ok, contact} ->
        # conn
        # |> put_flash(:info, "Contact updated successfully.")
        # |> redirect(to: contact_path(conn, :show, contact))
      # {:error, %Ecto.Changeset{} = changeset} ->
        # ad = Sales.get_ad!(contact_params["ad_id"])
        # render(conn, "edit.html", contact: contact, changeset: changeset, ad: ad)
    # end
  # end

  # def delete(conn, %{"id" => id}) do
    # contact = Sales.get_contact!(id)
    # {:ok, _contact} = Sales.delete_contact(contact)

    # conn
    # |> put_flash(:info, "Contact deleted successfully.")
    # |> redirect(to: contact_path(conn, :index))
  # end
end
