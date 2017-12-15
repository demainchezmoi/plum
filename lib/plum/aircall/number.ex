defmodule Plum.Aircall.Number do

  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Aircall.{
    Number,
    User
  }

  @primary_key {:id, :id, autogenerate: false}

  schema "aircall_numbers" do
		field :direct_link, :string
		field :name, :string
		field :digits, :string
		field :country, :string
		field :time_zone, :string
		field :open, :boolean
		field :availability_status, :string
		field :is_ivr, :boolean

    many_to_many :users, User,
      join_through: "aircall_users_aircall_numbers",
      join_keys: [aircall_number_id: :id, aircall_user_id: :id]

    field :messages, :map
  end

  @optional_fields ~w(
    messages
  )a

  @required_fields ~w(
		id
		direct_link
		name
		digits
		country
		time_zone
		open
		availability_status
		is_ivr
  )a

	# users
	# messages

  def changeset(%Number{} = number, attrs) do
    number
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
