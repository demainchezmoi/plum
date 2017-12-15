defmodule Plum.Aircall.User do

  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Aircall.{
    Number,
    User
  }

  @primary_key {:id, :id, autogenerate: false}

  schema "aircall_users" do
    field :direct_link, :string
    field :name, :string
    field :email, :string
    field :available, :boolean
    field :availability_status, :string

    many_to_many :numbers, Number,
      join_through: "aircall_users_aircall_numbers",
      join_keys: [aircall_user_id: :id, aircall_number_id: :id]
  end

  @optional_fields ~w()
  @required_fields ~w(
    id
    direct_link
    name
    email
    available
    availability_status
  )a

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
