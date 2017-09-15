defmodule Plum.Sales.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.{Contact, Ad}

  @required_message "Champ requis."

  schema "contacts" do
    belongs_to :ad, Ad

    field :email, :string
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @required_fields ~w(email phone name ad_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields, message: @required_message)
  end
end
