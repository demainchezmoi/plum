defmodule PlumWeb.AdController do
  use PlumWeb, :controller

  alias Plum.Repo
  alias Plum.Sales

  def public(conn, %{"id" => id}) do
    ad = Sales.get_ad_where!(id, %{active: true}) |> Repo.preload(:land)
    conn
    |> put_layout("landing.html")
    |> render("public.html", ad: ad)
  end
end
