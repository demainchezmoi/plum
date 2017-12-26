defmodule Plum.Geo.LandLocation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Geo.LandLocation

  embedded_schema do
    field :lat, :float
    field :lng, :float
  end

  @required_fields ~w(
    lat
    lng
  )a

  @optional_fields ~w(
  )

  def changeset(%LandLocation{} = land_location, attrs) do
    land_location
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

