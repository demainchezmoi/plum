defmodule PlumWeb.Api.CityController do
  use PlumWeb, :controller
  alias Plum.Repo
  alias Plum.Geo

  alias Plum.Geo.City

  action_fallback PlumWeb.FallbackController

  def autocomplete(conn, %{"search" => search}) do
    cities = Geo.cities_autocomplete(search)
    conn |> render("index.json", %{cities: cities})
  end

  def index(conn, params) do
    cities_query = Geo.list_cities_query(params)
    page = cities_query |> Repo.paginate(params)

    render conn, "index.json",
      cities: page.entries,
      page_number: page.page_number,
      total_pages: page.total_pages
  end

  def create(conn, %{"city" => city_params}) do
    params = city_params |> Map.put("to_be_called", true)
    with {:ok, %City{} = city} <- Geo.create_city(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_city_path(conn, :show, city))
      |> render("show.json", city: city)
    end
  end

  def show(conn, %{"id" => id}) do
    city = Geo.get_city!(id)
    render(conn, "show.json", city: city)
  end

  def update(conn, %{"id" => id, "city" => city_params}) do
    city = Geo.get_city!(id)
    with {:ok, %City{} = city} <- Geo.update_city(city, city_params) do
      render(conn, "show.json", city: city)
    end
  end

  def delete(conn, %{"id" => id}) do
    city = Geo.get_city!(id)
    with {:ok, %City{}} <- Geo.delete_city(city) do
      conn |> render(PlumWeb.Api.SuccessView, "deleted.json")
    end
  end
end
