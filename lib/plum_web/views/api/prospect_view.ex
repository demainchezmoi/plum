defmodule PlumWeb.Api.ProspectView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    CityView,
    ContactView,
    LandView,
    ProspectView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    cities
    contact
    garage_price
    house_price
    id
    inserted_at
    kitchen_price
    land_budget
    lands
    max_budget
    notes
    origin
    soil_price
    status
    terrace_price
    updated_at
    walls_ceiling_price
  )a

  def render("index.json", params = %{prospects: prospects}) do
    %{
      data: render_many(prospects, ProspectView, "prospect.json"),
      page_number: params[:page_number],
      total_pages: params[:total_pages],
    }
  end

  def render("show.json", %{prospect: prospect}) do
    %{data: render_one(prospect, ProspectView, "prospect.json")}
  end

  def render("prospect.json", %{prospect: prospect}) do
    prospect
    |> Map.take(@attributes)
    |> put_loaded_assoc({:contact, ContactView, "show.json", :contact})
    |> put_loaded_assoc({:lands, LandView, "index.json", :lands})
    |> put_loaded_assoc({:cities, CityView, "index.json", :cities})
  end
end
