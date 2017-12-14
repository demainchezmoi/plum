defmodule Plum.Aircall.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Aircall.User

  @primary_key false
  embedded_schema do
    field :id, :integer
    field :direct_link, :string
    field :name, :string
    field :email, :string
    field :available, :string
    field :availability_status, :string
    field :numbers, {:array, :string}
  end

  @optional_fields ~w()
  @required_fields ~w(
    id
    direct_link
    name
    email
    available
    availability_status
    numbers
  )a

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
