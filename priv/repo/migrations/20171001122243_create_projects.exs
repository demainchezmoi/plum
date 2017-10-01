defmodule Plum.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :ad_id, references(:ads, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:projects, [:ad_id])
    create index(:projects, [:user_id])
  end
end
