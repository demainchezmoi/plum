defmodule Plum.Geo.LandAd do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Geo.{Land, LandAd}


  schema "geo_land_ads" do
    field :link, :string
    field :origin, :string

    embeds_one :contact, Plum.Geo.LandAdContact
    belongs_to :land, Land

    timestamps()
  end

  @doc false
  def changeset(%LandAd{} = land_ad, attrs) do
    land_ad
    |> cast(attrs, [:link, :origin])
    |> cast_embed(:contact)
    |> validate_required([:link, :origin])
  end
end
