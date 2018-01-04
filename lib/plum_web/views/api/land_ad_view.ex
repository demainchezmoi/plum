defmodule PlumWeb.Api.LandAdView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    LandAdContactView,
    LandAdView,
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

  def render("index.json", %{land_ads: land_ads}) do
    %{data: render_many(land_ads, LandAdView, "land_ad.json")}
  end

  def render("show.json", %{land_ad: land_ad}) do
    %{data: render_one(land_ad, LandAdView, "land_ad.json")}
  end

  def render("land_ad.json", %{land_ad: land_ad}) do
    land_ad
    |> Map.take(@attributes)
    |> put_loaded_assoc({:contact, LandAdContactView, "show.json", :land_ad_contact})
    |> put_loaded_assoc({:land, LandView, "show.json", :land})
  end
end
