defmodule PlumWeb.PageController do
  use PlumWeb, :controller

  @spec index(Plug.Conn.t, map)::Plug.Conn.t
  def index(conn, _params) do
    conn
    |> put_layout("landing.html")
    |> render("index.html")
  end

  @spec merci(Plug.Conn.t, map)::Plug.Conn.t
  def merci(conn, _params) do
    render conn, "merci.html"
  end

  @spec confidentialite(Plug.Conn.t, map)::Plug.Conn.t
  def confidentialite(conn, _params) do
    render conn, "confidentialite.html"
  end
end
