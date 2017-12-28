defmodule PlumWeb.Api.LandAdContactView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    LandAdContactView,
  }

  @attributes ~w(
    id
    address
    city
    name
    phone
    postal_code
  )a

  def render("index.json", %{lands: lands}) do
    %{data: render_many(lands, LandView, "land.json")}
  end

  def render("show.json", %{land: land}) do
    %{data: render_one(land, LandView, "land.json")}
  end

  def render("land.json", %{land: land}) do
    land
    |> Map.take(@attributes)
  end
end

