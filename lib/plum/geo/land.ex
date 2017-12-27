defmodule Plum.Geo.Land do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Geo.{City, Land, LandAd, LandLocation}
  alias Plum.Helpers.NotaryFees

  schema "geo_lands" do
    field :description, :string
    field :images, {:array, :string}
    field :notary_fees, :integer
    field :price, :integer
    field :surface, :integer

    has_many :ads, LandAd
    belongs_to :city, City
    embeds_one :location, LandLocation, on_replace: :delete

    timestamps()
  end

  @required_params ~w()a
  @optional_params ~w(city_id surface price description images notary_fees)a

  @doc false
  def changeset(%Land{} = land, attrs) do
    land
    |> cast(attrs, @required_params ++ @optional_params)
    |> cast_embed(:location)
    |> set_notary_fees
    |> validate_required(@required_params)
  end

  def set_notary_fees(changeset) do
    price = get_field(changeset, :price) || 0
    changeset |> put_change(:notary_fees, NotaryFees.notary_fees(price))
  end
end
