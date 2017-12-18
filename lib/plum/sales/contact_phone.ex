defmodule Plum.Sales.ContactPhone do

  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Sales.{
    ContactPhone
  }

  @primary_key false
  embedded_schema do
    field :label, :string
    field :value, :string
  end

  @required_fields ~w(
  )a

  @optional_fields ~w(
    label
    value
  )a

  @doc false
  def changeset(%ContactPhone{} = contact_phone, attrs) do
    contact_phone
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end


