defmodule PlumWeb.AdController do
  use PlumWeb, :controller

  alias Plum.Repo
  alias Plum.Sales

  plug PlumWeb.Plugs.RequireLogin, {:html, []} when action in [:interested]

  def public(conn, %{"id" => id}) do
    ad = Sales.get_ad_where!(id, %{active: true}) |> Repo.preload(:land)
    conn
    |> put_layout("landing.html")
    |> render("public.html", ad: ad)
  end

  def login(conn, %{"id" => id}) do
    ad = Sales.get_ad_where!(id, %{active: true}) |> Repo.preload(:land)
    conn
    |> put_layout("landing.html")
    |> render("login.html", ad: ad)
  end

  def interested(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    id = id |> String.to_integer

    {:ok, project} = Sales.find_or_create_project(%{user_id: current_user.id, ad_id: id})

    path = page_path(conn, :prospect, ["projets", to_string(project.id)])
    conn |> redirect(to: path)
  end
end
