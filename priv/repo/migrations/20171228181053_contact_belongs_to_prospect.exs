defmodule Plum.Repo.Migrations.ContactBelongsToProspect do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :prospect_id, references(:sales_prospects, on_delete: :delete_all)
    end

    create index(:contacts, [:prospect_id])
  end
end
