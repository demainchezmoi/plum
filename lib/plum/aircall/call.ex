defmodule Plum.Aircall.Call do
  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Aircall.{
    Call,
    Contact,
    User
  }

  @primary_key false
  embedded_schema do
    field :id, :integer
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
    # field :number, :string
    embeds_one :user, User
    embeds_one :contact, Contact
    embeds_one :assigned_to, User 
    # field :comments, :string
    # field :tags, :string
  end

  @optional_fields ~w()a
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
  )a

  # number
  # user
  # contact
  # assigned_to
  # comments
  # tags

  def changeset(%Call{} = call, attrs) do
    call
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:user)
    |> cast_embed(:contact)
    |> cast_embed(:assigned_to)
    |> validate_required(@required_fields)
  end
end
