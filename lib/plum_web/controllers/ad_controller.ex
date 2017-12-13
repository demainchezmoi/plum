defmodule PlumWeb.AdController do
  use PlumWeb, :controller

  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Ad
  import Ecto.Query

  def public(conn, params = %{"id" => id}) do
    ad =
      Sales.get_ad!(id)
      |> Repo.preload(:land)
      |> Sales.increment_view_count!

    render conn, PlumWeb.PageView, "index.html",
      ad: ad,
      params: Map.put(params, :ad_id, id),
      conn: conn
  end

  def public_index(conn, _params) do
    ads =
      Ad
      |> preload(:land)
      |> where([ad], ad.active == true)
      |> Repo.all

    conn |> render("public_index.html", ads: ads)
  end

  def cgu(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id) |> Repo.preload(:land)
    conn |> render("cgu.html", ad: ad)
  end

  def index(conn, _params) do
    ads = Sales.list_ads()
    render(conn, "index.html", ads: ads)
  end

  def new(conn, _params) do
    changeset = Sales.change_ad(%Ad{})
    render(conn, "new.html", lands: get_lands(), changeset: changeset)
  end

  def create(conn, %{"ad" => ad_params}) do
    case Sales.create_ad(ad_params) do
      {:ok, ad} ->
        conn
        |> put_flash(:info, "Ad created successfully.")
        |> redirect(to: ad_path(conn, :show, ad))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", lands: get_lands(), changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id)
    render(conn, "show.html", ad: ad, lands: get_lands())
  end

  def edit(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id)
    changeset = Sales.change_ad(ad)
    render(conn, "edit.html", ad: ad, lands: get_lands(), changeset: changeset)
  end

  def update(conn, %{"id" => id, "ad" => ad_params}) do
    ad = Sales.get_ad!(id)

    case Sales.update_ad(ad, ad_params) do
      {:ok, ad} ->
        conn
        |> put_flash(:info, "Ad updated successfully.")
        |> redirect(to: ad_path(conn, :show, ad))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", ad: ad, lands: get_lands(), changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id)
    {:ok, _ad} = Sales.delete_ad(ad)

    conn
    |> put_flash(:info, "Ad deleted successfully.")
    |> redirect(to: ad_path(conn, :index))
  end

  defp get_lands do
    Sales.list_lands
  end
end
