defmodule PlumWeb.ContactController do
  use PlumWeb, :controller
  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Contact

  @spec create(Plug.Conn.t, map)::Plug.Conn.t
  def create(conn, %{"contact" => contact_params}) do
    case Sales.create_contact(contact_params) do
      {:ok, contact} ->
        conn |> redirect(to: contact_path(conn, :show, contact))
      {:error, %Ecto.Changeset{} = changeset} ->
        ad = Sales.get_ad!(contact_params["ad_id"])
        conn
        |> put_flash(:error, "Le formulaire est invalide, merci de corriger les erreurs ci-dessous.")
        |> render("new.html", changeset: changeset, ad: ad)
    end
  end

  @spec new(Plug.Conn.t, map)::Plug.Conn.t
  def new(conn, %{"ad" => ad_id}) do
    ad = Sales.get_ad!(ad_id)
    changeset = Sales.change_contact(%Contact{ad_id: ad.id})
    render(conn, "new.html", changeset: changeset, ad: ad)
  end

  @spec show(Plug.Conn.t, map)::Plug.Conn.t
  def show(conn, %{"id" => id}) do
    contact = Sales.get_contact!(id) |> Repo.preload(:ad)
    render(conn, "show.html", contact: contact)
  end
end
