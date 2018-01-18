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
    field :name, :string, virtual: true
    field :origin, :string
    field :type, :string
    field :company, :string

    belongs_to :prospect, Prospect
    belongs_to :estate_agent, EstateAgent

    embeds_many :emails, ContactEmail, on_replace: :delete
    field :email, :string, virtual: true

    embeds_many :phone_numbers, ContactPhone, on_replace: :delete
    field :phone_number, :string, virtual: true

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
    |> set_emails_from_virtual
    |> set_phone_numbers_from_virtual
    |> set_fname_lname_from_virtual
    |> cast_embed(:emails)
    |> cast_embed(:phone_numbers)
  end

  def set_emails_from_virtual(changeset) do
    case changeset.params do
      %{"email" => email} ->
        changeset |> put_change(:emails, [%{value: email, label: "Principal"}])
      _ ->  changeset
    end
  end

  def set_phone_numbers_from_virtual(changeset) do
    case changeset.params do
      %{"phone_number" => phone_number} ->
        changeset |> put_change(:phone_numbers, [%{value: phone_number, label: "Principal"}])
      _ ->  changeset
    end
  end

  def set_fname_lname_from_virtual(changeset) do
    case changeset.params do
      %{"name" => name} ->
        changeset
        |> put_change(:first_name, name |> String.split(" ") |> List.first)
        |> put_change(:last_name, name |> String.split(" ") |> Enum.drop(1) |> Enum.join(" "))
      _ ->  changeset
    end
  end
end
