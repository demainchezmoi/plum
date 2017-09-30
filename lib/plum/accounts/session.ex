defmodule Plum.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Accounts.Session


  schema "sessions" do
    field :token, :string
    belongs_to :user, Plum.Accounts.User

    timestamps()
  end

  @optional_fields ~w()a
  @required_fields ~w(user_id)a

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def with_token(changeset) do
    changeset |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
