defmodule Plum.Repo.Migrations.AdBelongsToLand do
  use Ecto.Migration

  def change do
    alter table(:ads) do
      add :land_id, references(:lands, on_delete: :delete_all)
    end
    create index(:ads, [:land_id])
  end
end
