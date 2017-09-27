defmodule PlumWeb.PageController do
  use PlumWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout("landing.html")
    |> render("index.html")
  end

  def technical(conn, _params) do
    conn
    |> put_layout("landing.html")
    |> render("technical.html")
  end

  def contact(conn, _params) do
    conn
    |> put_layout("landing.html")
    |> render("contact.html")
  end

  def merci(conn, _params) do
    conn
    |> put_layout("landing.html")
    |> render("merci.html")
  end

  def confidentialite(conn, _params) do
    conn
    |> put_layout("landing.html")
    |> render("confidentialite.html")
  end

  def admin(conn, _params) do
    conn |> render("admin.html")
  end
end
