defmodule Plum.Aircall.Call do

  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Aircall.{
    Call,
    Contact,
    Number,
    User
  }

  @primary_key {:id, :id, autogenerate: false}

  schema "aircall_calls" do
    field :direct_link, :string
    field :status, :string
    field :direction, :string
    field :started_at, :integer
    field :answered_at, :integer
    field :ended_at, :integer
    field :duration, :integer
    field :raw_digits, :string
    field :voicemail, :string
    field :recording, :string
    field :archived, :boolean
    field :missed_call_reason, :string

    belongs_to :number, Number
    belongs_to :user, User
    belongs_to :contact, Contact
    belongs_to :assigned_to, User

    field :comments, {:array, :map}
    field :tags, {:array, :map}
  end

  @optional_fields ~w(
    number_id
    user_id
    contact_id
    assigned_to_id
  )a

  @required_fields ~w(
    id
    direct_link
    status
    direction
    started_at
    answered_at
    ended_at
    duration
    raw_digits
    voicemail
    recording
    archived
    missed_call_reason
    comments
    tags
  )a

  def changeset(%Call{} = call, attrs) do
    call
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
