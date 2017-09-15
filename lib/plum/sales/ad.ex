defmodule Plum.Sales.Ad do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.{
    Ad,
    Contact,
    Land
  }


  schema "ads" do
    belongs_to :land, Land
    field :active, :boolean, default: true
    has_many :contacts, Contact
    timestamps()
  end

  @required_fields ~w(land_id)a
  @optional_fields ~w(active)a

  @doc false
  def changeset(%Ad{} = ad, attrs) do
    ad
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
