defmodule Plum.Sales.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Project


  schema "projects" do
    belongs_to :user, Plum.Accounts.User
    belongs_to :ad, Plum.Sales.Ad

    field :discover_land, :boolean, default: false
    field :discover_house, :boolean, default: false

    field :steps, {:array, :map}, virtual: true

    # field :house_color_1, :string
    # field :house_color_2, :string

    # field :contribution, :float

    # field :current_rent, :float -> on user
    # field :net_income, :float -> on user

    # field :phone_called

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

  @optional_fields ~w(discover_land discover_house)a
  @required_fields ~w(user_id ad_id)a

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
