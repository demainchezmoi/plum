defmodule Plum.Sales.Location do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Location

  embedded_schema do
    field :lat, :float
    field :lng, :float
  end

  @required_fields ~w(
    lat
    lng
  )a

  @optional_fields ~w()

  def changeset(%Location{} = location, attrs) do
    location
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
