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

  def render("index.json", %{land_ad_contacts: land_ad_contacts}) do
    %{data: render_many(land_ad_contacts, LandAdContactView, "land_ad_contact.json")}
  end

  def render("show.json", %{land_ad_contact: land_ad_contact}) do
    %{data: render_one(land_ad_contact, LandAdContactView, "land_ad_contact.json")}
  end

  def render("land_ad_contact.json", %{land_ad_contact: land_ad_contact}) do
    land_ad_contact
    |> Map.take(@attributes)
  end
end

