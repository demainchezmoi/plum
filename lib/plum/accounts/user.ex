defmodule Plum.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Accounts.User
  alias Plum.Aircall
  alias Plum.Accounts.AuthToken

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :admin, :boolean, default: false
    field :email, :string
    field :facebook_id, :string
    field :roles, {:array, :string}, default: []
    belongs_to :aircall_user, Aircall.User
    has_many :aircall_user_calls, through: [:aircall_user, :calls]
    has_many :auth_tokens, AuthToken

    timestamps()
  end

  @optional_fields ~w(
    aircall_user_id
    email
    first_name
    last_name
    roles
  )a

  @required_fields ~w(
    facebook_id
    admin
  )a

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
