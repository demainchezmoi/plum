defmodule Plum.Repo.Migrations.AddAdIdToContact do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :ad_id, references(:ads, on_delete: :delete_all)
    end
    create index(:contacts, [:ad_id])
  end
end
