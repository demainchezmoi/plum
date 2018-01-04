defmodule Plum.Sales.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Aircall

  alias Plum.Sales.{
    Contact,
    ContactEmail,
    ContactPhone,
    EstateAgent,
    Prospect,
  }

  schema "contacts" do
    belongs_to :aircall_contact, Aircall.Contact
    has_many :aircall_contact_calls, through: [:aircall_contact, :calls]
    field :first_name, :string
    field :last_name, :string
    field :origin, :string
    field :type, :string
    field :company, :string

    belongs_to :prospect, Prospect
    belongs_to :estate_agent, EstateAgent

    embeds_many :emails, ContactEmail, on_replace: :delete
    embeds_many :phone_numbers, ContactPhone, on_replace: :delete
    timestamps()
  end

  @required_fields ~w(
  )a

  @optional_fields ~w(
    aircall_contact_id
    first_name
    last_name
    origin
    type
    company
  )a

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:emails)
    |> cast_embed(:phone_numbers)
  end
end
