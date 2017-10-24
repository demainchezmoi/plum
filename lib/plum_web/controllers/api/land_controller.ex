defmodule PlumWeb.Api.LandController do
  use PlumWeb, :controller
  alias Plum.Sales
  alias Plum.Sales.Land

  action_fallback PlumWeb.FallbackController

  def index(conn, _params) do
    lands = Sales.list_lands()
    conn |> render("index.json", lands: lands)
  end

  def create(conn, %{"land" => land_params}) do
    with {:ok, %Land{} = land} <- Sales.create_land(land_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_land_path(conn, :show, land))
      |> render("show.json", land: land)
    end
  end

  def show(conn, %{"id" => id}) do
    land = Sales.get_land!(id)
    render(conn, "show.json", land: land)
  end

  def update(conn, %{"id" => id, "land" => land_params}) do
    land = Sales.get_land!(id)
    with {:ok, %Land{} = land} <- Sales.update_land(land, land_params) do
      render(conn, "show.json", land: land)
    end
  end

  def delete(conn, %{"id" => id}) do
    land = Sales.get_land!(id)
    with {:ok, %Land{}} <- Sales.delete_land(land) do
      conn |> render(PlumWeb.Api.SuccessView, "deleted.json")
    end
  end
end
