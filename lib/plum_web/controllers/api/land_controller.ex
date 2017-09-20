defmodule PlumWeb.Api.LandController do
  use PlumWeb, :controller
  alias Plum.Sales

  def index(conn, _params) do
    lands = Sales.list_lands()
    conn |> render("index.json", lands: lands)
  end
end
