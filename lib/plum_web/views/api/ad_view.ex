defmodule PlumWeb.Api.AdView do
  use PlumWeb, :view
  alias PlumWeb.Api.{
    AdView,
    LandView,
  }
  import PlumWeb.ViewHelpers

  @attributes ~w(
    id
    active
    land
    house_price
  )a

  def render("index.json", %{ads: ads}) do
    %{data: render_many(ads, AdView, "ad.json")}
  end

  def render("show.json", %{ad: ad}) do
    %{data: render_one(ad, AdView, "ad.json")}
  end

  def render("ads.json", %{ads: ads}) do
    render_many(ads, AdView, "ad.json")
  end

  def render("ad.json", %{ad: ad}) do
    ad
    |> Map.take(@attributes)
    |> put_loaded_assoc({:land, LandView, "land.json", :land})
  end
end

