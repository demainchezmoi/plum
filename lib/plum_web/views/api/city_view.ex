defmodule PlumWeb.Api.CityView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    CityView,
  }

  @attributes ~w(
    id
    insee_id
    name
    postal_code
  )a

  def render("index.json", %{cities: cites}) do
    %{data: render_many(cites, CityView, "city.json")}
  end

  def render("show.json", %{city: city}) do
    %{data: render_one(city, CityView, "city.json")}
  end

  def render("city.json", %{city: city}) do
    city |> Map.take(@attributes)
  end
end


