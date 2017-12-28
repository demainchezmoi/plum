defmodule PlumWeb.Api.ProspectView do
  use PlumWeb, :view

  alias PlumWeb.Api.{
    ContactView,
    LandView,
    ProspectView,
  }

  import PlumWeb.ViewHelpers, only: [put_loaded_assoc: 2]

  @attributes ~w(
    max_budget
    inserted_at
    updated_at
    id
    contact
    lands
    cities
  )a

  def render("index.json", %{prospects: prospects}) do
    %{data: render_many(prospects, ProspectView, "prospect.json")}
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
