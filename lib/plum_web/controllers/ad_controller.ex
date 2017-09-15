defmodule PlumWeb.AdController do
  use PlumWeb, :controller

  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Ad
  alias Plum.Sales.Contact

  def index(conn, _params) do
    ad = Sales.list_ad()
    render(conn, "index.html", ad: ad)
  end

  def new(conn, _params) do
    changeset = Sales.change_ad(%Ad{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"ad" => ad_params}) do
    case Sales.create_ad(ad_params) do
      {:ok, ad} ->
        conn
        |> put_flash(:info, "Ad created successfully.")
        |> redirect(to: ad_path(conn, :show, ad))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id) |> Repo.preload(:land)
    contact_changeset = Sales.change_contact(%Contact{}) 
    render(conn, "show.html", ad: ad, contact_changeset: contact_changeset)
  end

  def edit(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id)
    changeset = Sales.change_ad(ad)
    render(conn, "edit.html", ad: ad, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ad" => ad_params}) do
    ad = Sales.get_ad!(id)

    case Sales.update_ad(ad, ad_params) do
      {:ok, ad} ->
        conn
        |> put_flash(:info, "Ad updated successfully.")
        |> redirect(to: ad_path(conn, :show, ad))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", ad: ad, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id)
    {:ok, _ad} = Sales.delete_ad(ad)

    conn
    |> put_flash(:info, "Ad deleted successfully.")
    |> redirect(to: ad_path(conn, :index))
  end
end
