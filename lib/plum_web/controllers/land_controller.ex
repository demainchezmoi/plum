defmodule PlumWeb.LandController do
  use PlumWeb, :controller

  alias Plum.Sales
  alias Plum.Sales.Land

  def index(conn, _params) do
    lands = Sales.list_lands()
    render(conn, "index.html", lands: lands)
  end

  def new(conn, _params) do
    changeset = Sales.change_land(%Land{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"land" => land_params}) do
    case Sales.create_land(land_params) do
      {:ok, land} ->
        conn
        |> put_flash(:info, "Land created successfully.")
        |> redirect(to: land_path(conn, :show, land))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    land = Sales.get_land!(id)
    render(conn, "show.html", land: land)
  end

  def edit(conn, %{"id" => id}) do
    land = Sales.get_land!(id)
    changeset = Sales.change_land(land)
    render(conn, "edit.html", land: land, changeset: changeset)
  end

  def update(conn, %{"id" => id, "land" => land_params}) do
    land = Sales.get_land!(id)

    case Sales.update_land(land, land_params) do
      {:ok, land} ->
        conn
        |> put_flash(:info, "Land updated successfully.")
        |> redirect(to: land_path(conn, :show, land))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", land: land, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    land = Sales.get_land!(id)
    {:ok, _land} = Sales.delete_land(land)

    conn
    |> put_flash(:info, "Land deleted successfully.")
    |> redirect(to: land_path(conn, :index))
  end
end
