defmodule PlumWeb.PageController do
  use PlumWeb, :controller
  alias PlumWeb.Email
  alias PlumWeb.Mailer

  plug PlumWeb.Plugs.JustInsertedUser when action in [:prospect]

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def merci(conn, _params) do
    conn |> render("merci.html")
  end

  def confidentialite(conn, _params) do
    conn |> render("confidentialite.html")
  end

  def admin(conn, _params) do
    conn
    |> put_layout("elm-admin.html")
    |> render("admin.html")
  end

  def prospect(conn, _params) do
    conn
    |> put_layout("elm-prospect.html")
    |> render("prospect.html")
  end

  def login(conn, _params) do
    conn |> render("login.html", query_params: conn.query_params)
  end

  def contact(conn, %{"contact" => contact_params}) do
    if contact_params["phone"] != "" do
      Email.contact_email(contact_params) |> Mailer.deliver
      conn |> put_flash(:info, "Votre demande de contact a bien été prise en compte.")
    else
      conn |> put_flash(:error, "Merci de renseigner votre numéro de téléphone pour prendre contact.")
    end
    |> render("index.html")
  end
end
