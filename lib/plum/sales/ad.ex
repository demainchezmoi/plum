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
    field :land_adaptation_price, :integer, default: 15_000
    timestamps()
  end

  @required_fields ~w(land_id house_price active land_adaptation_price)a
  @optional_fields ~w()a

  @doc false
  def changeset(%Ad{} = ad, attrs) do
    ad
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
