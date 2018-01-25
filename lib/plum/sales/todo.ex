defmodule Plum.Sales.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias Plum.Sales.{
    Prospect,
    Todo,
  }

  schema "sales_todos" do
    field :done, :boolean, default: false
    field :priority, :integer, default: 10
    field :start_date, :date 
    field :title, :string
    belongs_to :prospect, Prospect
    timestamps()
  end

  @required_fields ~w(
  )a

  @optional_fields ~w(
    done
    priority
    prospect_id
    start_date
    title
  )a

  @doc false
  def changeset(%Todo{} = todo, attrs) do
    todo
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

