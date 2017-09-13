defmodule PlumWeb.PageController do
  use PlumWeb, :controller

  @spec index(Plug.Conn.t, map)::Plug.Conn.t
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec index(Plug.Conn.t, map)::Plug.Conn.t
  def merci(conn, _params) do
    render conn, "merci.html"
  end

  @spec index(Plug.Conn.t, map)::Plug.Conn.t
  def confidentialite(conn, _params) do
    render conn, "confidentialite.html"
  end
end
