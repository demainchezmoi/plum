defmodule Plum.Sales.Ad do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Ad


  schema "ad" do
    field :land_lat, :float
    field :land_lng, :float
    field :land_price, :integer
    field :land_surface, :integer

    timestamps()
  end

  @doc false
  def changeset(%Ad{} = ad, attrs) do
    ad
    |> cast(attrs, [:land_surface, :land_price, :land_lat, :land_lng])
    |> validate_required([:land_surface, :land_price, :land_lat, :land_lng])
  end
end
