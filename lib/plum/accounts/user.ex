defmodule Plum.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Accounts.User


  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :facebook_id, :string
    field :roles, {:array, :string}, default: []

    timestamps()
  end

  @optional_fields ~w(email roles)a
  @required_fields ~w(facebook_id admin)a

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
  end
end
