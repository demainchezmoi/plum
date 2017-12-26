defmodule Plum.Geo.City do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Geo.City


  schema "geo_cities" do
    field :insee_id, :string
    field :name, :string
    field :postal_code, :string

    timestamps()
  end

  @required_params ~w(insee_id name)a
  @optional_params ~w(postal_code)a

  @doc false
  def changeset(%City{} = city, attrs) do
    city
    |> cast(attrs, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> unique_constraint(:insee_id)
  end
end
