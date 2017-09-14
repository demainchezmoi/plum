defmodule PlumWeb.ContactController do
  use PlumWeb, :controller
  alias Plum.Sales
  alias Plum.Sales.Contact

  @spec create(Plug.Conn.t, map)::Plug.Conn.t
  def create(conn, %{"contact" => contact_params}) do
    case Sales.create_contact(contact_params) do
      {:ok, contact} ->
        conn |> redirect(to: contact_path(conn, :show, contact))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Le formulaire est invalide, veuillez corriger les erreurs ci-dessous.")
        |> render("new.html", changeset: changeset)
    end
  end

  @spec new(Plug.Conn.t, map)::Plug.Conn.t
  def new(conn, _params) do
    changeset = Sales.change_contact(%Contact{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec show(Plug.Conn.t, map)::Plug.Conn.t
  def show(conn, %{"id" => id}) do
    contact = Sales.get_contact!(id)
    render(conn, "show.html", contact: contact)
  end
end
