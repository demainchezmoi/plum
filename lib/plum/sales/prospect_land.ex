defmodule Plum.Sales.ProspectLand do
  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Geo.{
    Land
  }

  alias Plum.Sales.{
    Prospect,
    ProspectLand
  }

  schema "sales_prospects_geo_lands" do
    field :status, :string

    belongs_to :land, Land
    belongs_to :prospect, Prospect

    timestamps()
  end

  @required_fields ~w(status)a
  @optional_fields ~w(land_id prospect_id)a

  def changeset(%ProspectLand{} = prospect_land, params \\ %{}) do
    prospect_land
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
