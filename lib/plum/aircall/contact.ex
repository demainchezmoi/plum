defmodule Plum.Aircall.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Aircall.{
    Call,
    Contact
  }

  @primary_key {:id, :id, autogenerate: false}

  schema "aircall_contacts" do
    field :direct_link, :string
    field :first_name, :string
    field :last_name, :string
    field :company_name, :string
    field :information, :string

    field :phone_numbers, {:array, :map}
    field :emails, {:array, :map}

    has_many :calls, Call
    has_one :contact, Plum.Sales.Contact, foreign_key: :aircall_contact_id
  end

  @optional_fields ~w(
    direct_link
    first_name
    last_name
    company_name
    information
    phone_numbers
    emails
  )a

  @required_fields ~w(
    id
  )a

  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
