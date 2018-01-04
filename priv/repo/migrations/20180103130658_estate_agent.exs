defmodule Plum.Repo.Migrations.EstateAgent do
  use Ecto.Migration

  def change do
    create table(:sales_estate_agents) do
      add :notes, :text
      timestamps()
    end

    alter table(:contacts) do
      add :estate_agent_id, references(:sales_estate_agents, on_delete: :delete_all)
    end
    create index(:contacts, [:estate_agent_id])

    alter table(:geo_lands) do
      add :estate_agent_id, references(:sales_estate_agents, on_delete: :nilify_all)
    end
    create index(:geo_lands, [:estate_agent_id])
  end
end
