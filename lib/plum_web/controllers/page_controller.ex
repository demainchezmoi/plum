defmodule PlumWeb.PageController do
  use PlumWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout("landing.html")
    |> render("index.html")
  end

  def merci(conn, _params) do
    render conn, "merci.html"
  end

  def confidentialite(conn, _params) do
    render conn, "confidentialite.html"
  end

  def admin(conn, _params) do
    conn
    |> put_layout("elm.html")
    |> render("admin.html")
  end
end
