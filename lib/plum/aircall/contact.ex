defmodule Plum.Aircall.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Aircall.Contact

  @primary_key false
  embedded_schema do
    field :id, :integer
    field :direct_link, :string
    field :first_name, :string
    field :last_name, :string
    field :company_name, :string
    field :information, :string
    field :phone_numbers, {:array, :string}
    field :emails, {:array, :string}
  end

  @optional_fields ~w()a
  @required_fields ~w(
    id
    direct_link
    first_name
    last_name
    company_name
    information
    phone_numbers
    emails
  )a

  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
