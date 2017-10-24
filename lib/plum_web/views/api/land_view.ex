defmodule PlumWeb.Api.LandView do
  use PlumWeb, :view
  import PlumWeb.ViewHelpers
  alias PlumWeb.Api.{
    AdView,
  }
  @attributes ~w(
    ads
    city
    department
    description
    id
    images
    location
    notary_fees
    price
    surface
  )a

  def render("index.json", %{lands: lands}) do
    %{data: render_many(lands, __MODULE__, "land.json")}
  end

  def render("show.json", %{land: land}) do
    %{data: render_one(land, __MODULE__, "land.json")}
  end

  def render("land.json", %{land: land}) do
    land
    |> Map.take(@attributes)
    |> put_loaded_assoc({:ads, AdView, "ads.json", :ads})
  end
end
