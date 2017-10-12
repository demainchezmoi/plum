defmodule PlumWeb.AdController do
  use PlumWeb, :controller

  alias Plum.Repo
  alias Plum.Sales
  alias PlumWeb.Mailer
  alias PlumWeb.Email

  plug PlumWeb.Plugs.RequireLogin, {:html, []} when action in [:interested]

  def public(conn, %{"id" => id}) do
    ad = Sales.get_ad_where!(id, %{active: true}) |> Repo.preload(:land)
    conn
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

    {status, project} =  Sales.find_or_create_project(%{user_id: current_user.id, ad_id: id})

    if status == :created and not is_nil current_user.email do
      Email.new_project_email(current_user, project) |> Mailer.deliver
    end

    path = page_path(conn, :prospect, ["projets", to_string(project.id), "bienvenue"])
    conn |> redirect(to: path)
  end
end
