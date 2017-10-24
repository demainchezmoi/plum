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
    land_id
    link
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
    |> Map.put(:link, ad_url(PlumWeb.Endpoint, :public, ad))
    |> Map.take(@attributes)
    |> put_loaded_assoc({:land, LandView, "land.json", :land})
  end
end

