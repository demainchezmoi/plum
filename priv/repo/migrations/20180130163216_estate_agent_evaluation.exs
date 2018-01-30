defmodule Plum.Repo.Migrations.EstateAgentEvaluation do
  use Ecto.Migration

  def change do
    alter table(:sales_estate_agents) do
      add :evaluation, :string
    end
  end
end
