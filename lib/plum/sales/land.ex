defmodule Plum.Sales.Land do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Land
  alias Plum.Sales.Ad
  alias Plum.Helpers.NotaryFees

  schema "lands" do
    field :city, :string
    field :department, :string
    field :description, :string, default: ""
    field :images, {:array, :string}, default: []
    field :location, :map
    field :notary_fees, :integer
    field :price, :integer
    field :surface, :integer

    has_one :ad, Ad

    timestamps()
  end

  @optional_fields ~w(location)a
  @required_fields ~w(
    city
    department
    description
    images
    notary_fees
    price
    surface
  )a

  @doc false
  def changeset(%Land{} = land, attrs) do
    land
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> set_notary_fees
    |> validate_required(@required_fields)
  end

  def set_notary_fees(changeset) do
    price = get_field(changeset, :price) || 0
    changeset |> put_change(:notary_fees, NotaryFees.notary_fees(price))
  end
end
