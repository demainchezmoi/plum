defmodule Plum.Repo.Migrations.OnDeleteConstraints do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE sessions DROP CONSTRAINT sessions_user_id_fkey"
    alter table(:sessions) do
      modify :user_id, references(:users, on_delete: :delete_all)
    end

    execute "ALTER TABLE projects DROP CONSTRAINT projects_ad_id_fkey"
    execute "ALTER TABLE projects DROP CONSTRAINT projects_user_id_fkey"
    alter table(:projects) do
      modify :ad_id, references(:ads, on_delete: :delete_all)
      modify :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
