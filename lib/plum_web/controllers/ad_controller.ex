defmodule PlumWeb.AdController do
  use PlumWeb, :controller

  alias Plum.Repo
  alias Plum.Sales
  alias PlumWeb.Mailer
  alias PlumWeb.Email

  plug PlumWeb.Plugs.RequireLogin, {:html, []} when action in [:interested]

  def public(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id) |> Repo.preload(:land)
    conn |> render("public.html", ad: ad)
  end

  def login(conn, %{"id" => id}) do
    ad = Sales.get_ad_by!(%{id: id, active: true}) |> Repo.preload(:land)
    conn |> render("login.html", ad: ad)
  end

  def cgu(conn, %{"id" => id}) do
    ad = Sales.get_ad!(id) |> Repo.preload(:land)
    conn |> render("cgu.html", ad: ad)
  end

  def interested(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    id = id |> String.to_integer
    Sales.get_ad_by!(%{id: id, active: true})

    {status, project} = Sales.find_or_create_project(%{user_id: current_user.id, ad_id: id})

    if status == :created and not is_nil current_user.email do
      Email.new_project_email(current_user, project) |> Mailer.deliver
    end

    path = page_path(conn, :prospect, ["projets", to_string(project.id), "la-maison"])
    conn |> redirect(to: path)
  end
end
