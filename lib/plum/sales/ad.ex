defmodule Plum.Sales.Ad do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.{
    Ad,
    Land
  }

  schema "ads" do
    belongs_to :land, Land
    field :active, :boolean, default: true
    field :house_price, :integer, default: 89_000
    field :adaptation_fees, :integer
    field :view_count, :integer, default: 0
    timestamps()
  end

  @required_fields ~w(
    house_price
    active
  )a

  @optional_fields ~w(
    land_id
    adaptation_fees
    view_count
  )a

  @doc false
  def changeset(%Ad{} = ad, attrs) do
    ad
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
