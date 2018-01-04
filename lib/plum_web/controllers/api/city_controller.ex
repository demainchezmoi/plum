defmodule PlumWeb.Api.CityController do
  use PlumWeb, :controller

  alias Plum.Geo

  def autocomplete(conn, %{"search" => search}) do
    cities = Geo.cities_autocomplete(search)
    conn |> render("index.json", %{cities: cities})
  end
end
