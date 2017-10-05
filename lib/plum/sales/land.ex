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
    field :images, {:array, :string}, default: []
    field :description, :string, default: ""

    has_one :ad, Ad

    timestamps()
  end

  @optional_fields ~w()a
  @required_fields ~w(surface lat lng price city department images description)a

  @doc false
  def changeset(%Land{} = land, attrs) do
    land
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
