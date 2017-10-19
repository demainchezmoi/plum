defmodule Plum.Sales.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Project

  schema "projects" do
    belongs_to :user, Plum.Accounts.User
    belongs_to :ad, Plum.Sales.Ad

    field :discover_land, :boolean, default: false
    field :discover_house, :boolean, default: false
    field :contribution, :integer
    field :net_income, :integer
    field :phone_call, :boolean, default: false
    field :phone_number, :string

    field :steps, {:array, :map}, virtual: true

    # checked_quotation
    # checked_funding
    # checked_visit_land
    # checked_contract
    # checked_permit
    # checked_building
    # checked_keys
    # checked_after_sales

    timestamps()
  end

  @optional_fields ~w(
    net_income
    contribution
    phone_number
  )a

  @required_fields ~w(
    ad_id
    discover_house
    discover_land
    phone_call
    user_id
  )a

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
