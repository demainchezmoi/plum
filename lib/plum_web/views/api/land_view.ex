defmodule PlumWeb.Api.LandView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    CityView,
    LandView,
    LandAdView,
    ProspectView,
    EstateAgentView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    id
    description
    images
    notary_fees
    price
    surface
    address
    land_register_ref
    serviced
    slope
    type
    soc
    on_field_elements
    accessibility
    sanitation
    environment
    geoportail
    googlemaps
    openstreetmaps
    ads
    city
    city_id
    location
    prospects
    inserted_at
    estate_agent
    estate_agent_id
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
    |> put_loaded_assoc({:ads, LandAdView, "index.json", :land_ads})
    |> put_loaded_assoc({:city, CityView, "show.json", :city})
    |> put_loaded_assoc({:prospects, ProspectView, "index.json", :prospects})
    |> put_loaded_assoc({:estate_agent, EstateAgentView, "show.json", :estate_agent})
  end
end
