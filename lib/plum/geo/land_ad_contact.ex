defmodule Plum.Geo.LandAdContact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Geo.{LandAdContact}

  embedded_schema do
    field :address, :string
    field :city, :string
    field :name, :string
    field :phone, :string
    field :postal_code, :string
  end

  @required_params ~w()a
  @optional_params ~w(address city name phone postal_code)a

  @doc false
  def changeset(%LandAdContact{} = land_ad_contact, attrs) do
    land_ad_contact
    |> cast(attrs, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end
end
