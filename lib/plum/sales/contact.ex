defmodule Plum.Sales.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Contact

  @required_message "Champ requis."

  schema "contact" do
    field :email, :string
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, [:email, :phone, :name])
    |> validate_required([:email, :phone, :name], message: @required_message)
  end
end
