defmodule Plum.Geo.Land do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Helpers.Geo, as: GeoHelpers
  alias Plum.Geo.{City, Land, LandAd}
  alias Plum.Helpers.NotaryFees
  alias Plum.Sales.{EstateAgent, Prospect, ProspectLand}

  schema "geo_lands" do
    field :description, :string
    field :images, {:array, :string}
    field :notary_fees, :integer
    field :price, :integer
    field :surface, :integer

    field :address, :string
    field :land_register_ref, :string
    field :serviced, :boolean
    field :slope, :string
    field :type, :string
    field :soc, :float
    field :on_field_elements, :string
    field :accessibility, :string
    field :sanitation, :string
    field :environment, :string
    field :geoportail, :string
    field :googlemaps, :string
    field :openstreetmaps, :string

    has_many :ads, LandAd
    belongs_to :city, City
    belongs_to :estate_agent, EstateAgent

    many_to_many :prospects, Prospect,
      join_through: ProspectLand,
      join_keys: [land_id: :id, prospect_id: :id],
      on_replace: :delete

    has_many :prospects_lands, ProspectLand

    field :lng, :float, virtual: true
    field :lat, :float, virtual: true
    field :location, Geo.Geometry

    timestamps()
  end

  @required_params ~w()a
  @optional_params ~w(
    city_id surface price description images notary_fees
    address land_register_ref serviced slope type soc
    on_field_elements accessibility sanitation environment
    geoportail googlemaps openstreetmaps estate_agent_id
    location lat lng
  )a

  @doc false
  def changeset(%Land{} = land, attrs) do
    land
    |> cast(attrs, @required_params ++ @optional_params)
    |> set_notary_fees
    |> validate_required(@required_params)
    |> set_location_from_address
    |> GeoHelpers.put_location
    |> set_geoportail_link
    |> set_googlemaps_link
    |> set_openstreetmaps_link
  end

  def set_location_from_address(changeset) do
    with %{address: address} <- changeset.changes,
      location = %Geo.Point{} <- GeoHelpers.get_location(address)
    do
      changeset |> put_change(:location, location)
    else
      _ -> changeset
    end
  end

  def set_notary_fees(changeset) do
    price = get_field(changeset, :price) || 0
    changeset |> put_change(:notary_fees, NotaryFees.notary_fees(price))
  end

  def set_geoportail_link(changeset = %{changes: %{location: %Geo.Point{coordinates: {lng, lat}}}}) do
    changeset |> put_change(:geoportail, get_geoportail_link(lng, lat))
  end
  def set_geoportail_link(changeset), do: changeset

  def set_googlemaps_link(changeset = %{changes: %{location: %Geo.Point{coordinates: {lng, lat}}}}) do
    changeset |> put_change(:googlemaps, get_googlemaps_link(lng, lat))
  end
  def set_googlemaps_link(changeset), do: changeset

  def set_openstreetmaps_link(changeset = %{changes: %{location: %Geo.Point{coordinates: {lng, lat}}}}) do
    changeset |> put_change(:openstreetmaps, get_openstreetmaps_link(lng, lat))
  end

  def set_openstreetmaps_link(changeset), do: changeset

  defp get_geoportail_link(lng, lat) do
    "https://www.geoportail.gouv.fr/carte?c=#{lng},#{lat}&z=18&l0=ORTHOIMAGERY.ORTHOPHOTOS::GEOPORTAIL:OGC:WMTS(1)&l1=CADASTRALPARCELS.PARCELS::GEOPORTAIL:OGC:WMTS(1)&permalink=yes"
  end

  defp get_googlemaps_link(lng, lat) do
    "https://www.google.fr/maps/@#{lat},#{lng},770m/data=!3m1!1e3"
  end

  defp get_openstreetmaps_link(lng, lat) do
    "https://www.openstreetmap.org/#map=18/#{lat}/#{lng}"
  end
end
