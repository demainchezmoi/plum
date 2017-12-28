defmodule PlumWeb.Api.LandAdView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    LandAdContactView,
    LandView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    id
    link
    origin
    contact
    land
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
    |> put_loaded_assoc({:contact, LandAdContactView, "show.json", :contact})
    |> put_loaded_assoc({:land, LandView, "show.json", :land})
  end
end
