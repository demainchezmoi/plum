defmodule Plum.Sales.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plum.Sales.Project


  schema "projects" do
    belongs_to :user, Plum.Accounts.User
    belongs_to :ad, Plum.Sales.Ad

    timestamps()
  end

  @optional_fields ~w()a
  @required_fields ~w(user_id ad_id)a

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
