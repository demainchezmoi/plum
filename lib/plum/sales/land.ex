defmodule Plum.Sales.Land do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Land
  alias Plum.Sales.Ad

  schema "lands" do
    field :city, :string
    field :department, :string
    field :lat, :float
    field :lng, :float
    field :price, :integer
    field :surface, :integer

    has_one :ad, Ad

    timestamps()
  end

  @required_fields ~w(surface lat lng price city department)a
  @optional_fields ~w()a

  @doc false
  def changeset(%Land{} = land, attrs) do
    land
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields ++ @optional_fields)
  end
end
