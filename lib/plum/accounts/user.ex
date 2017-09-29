defmodule Plum.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Accounts.User


  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :facebook_id, :string

    timestamps()
  end

  @optional_params ~w(facebook_id)a
  @required_params ~w(email admin)a

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @optional_params ++ @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email)
  end
end
