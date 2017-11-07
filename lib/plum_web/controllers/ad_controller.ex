defmodule PlumWeb.AdController do
  use PlumWeb, :controller

  alias Plum.Repo
  alias Plum.Sales
  alias Plum.Sales.Ad
  import Ecto.Query

  def public(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id) |> Repo.preload(:land)
    conn |> render("public.html", ad: ad)
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
end
