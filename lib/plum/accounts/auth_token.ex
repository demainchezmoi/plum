defmodule Plum.Accounts.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

	alias Plum.Accounts.User
  alias Phoenix.Token
  alias PlumWeb.Endpoint

  schema "auth_tokens" do
    field :value, :string
    belongs_to :user, User

    timestamps(updated_at: false)
  end

  def changeset(struct, user) do
    struct
    |> cast(%{}, []) # convert the struct without taking any params
    |> put_assoc(:user, user)
    |> put_change(:value, generate_token(user))
    |> validate_required([:value, :user])
    |> unique_constraint(:value)
  end

  # generate a random and url-encoded token of given length
  defp generate_token(nil), do: nil
  defp generate_token(user) do
    Token.sign(Endpoint, "user", user.id)
  end
end
