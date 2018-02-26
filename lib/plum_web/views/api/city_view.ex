defmodule PlumWeb.Api.CityView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    CityView,
    LandView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    id
    insee_id
    name
    postal_code
    lands
    location
  )a

  def render("index.json", %{cities: cites}) do
    %{data: render_many(cites, CityView, "city.json")}
  end

  def render("show.json", %{city: city}) do
    %{data: render_one(city, CityView, "city.json")}
  end

  def render("city.json", %{city: city}) do
    city
    |> Map.take(@attributes)
    |> format_geo(:location)
    |> put_loaded_assoc({:lands, LandView, "index.json", :lands})
  end

  def format_geo(struct, field) do
    case struct |> Map.get(field) do
      nil -> struct
      value -> struct |> Map.put(field, value |> Geo.JSON.encode)
    end
  end
end
