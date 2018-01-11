defmodule PlumWeb.Api.LandView do
  use PlumWeb, :view

  alias Plum.Helpers.Geo, as: GeoHelpers

  alias PlumWeb.Api.{
    CityView,
    LandView,
    LandAdView,
    ProspectView,
    EstateAgentView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    accessibility
    address
    ads
    city
    city_id
    description
    environment
    estate_agent
    estate_agent_id
    geoportail
    googlemaps
    id
    images
    inserted_at
    land_register_ref
    location
    notary_fees
    on_field_elements
    openstreetmaps
    price
    prospects
    sanitation
    serviced
    slope
    soc
    surface
    type
  )a

  def render("index.json", params = %{lands: lands}) do
    %{
      data: render_many(lands, LandView, "land.json"),
      page_number: params[:page_number],
      total_pages: params[:total_pages],
    }
  end

  def render("show.json", %{land: land}) do
    %{data: render_one(land, LandView, "land.json")}
  end

  def render("land.json", %{land: land}) do
    land
    |> Map.take(@attributes)
    |> GeoHelpers.format_geo(:location)
    |> put_loaded_assoc({:ads, LandAdView, "index.json", :land_ads})
    |> put_loaded_assoc({:city, CityView, "show.json", :city})
    |> put_loaded_assoc({:prospects, ProspectView, "index.json", :prospects})
    |> put_loaded_assoc({:estate_agent, EstateAgentView, "show.json", :estate_agent})
  end
end
