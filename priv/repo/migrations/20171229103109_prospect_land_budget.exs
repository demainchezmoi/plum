defmodule Plum.Repo.Migrations.ProspectLandBudget do
  use Ecto.Migration

  def change do
    alter table(:sales_prospects) do
      add :land_budget, :integer
    end
  end
end
