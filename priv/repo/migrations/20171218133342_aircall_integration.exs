defmodule Plum.Repo.Migrations.AircallIntegration do
  use Ecto.Migration

  def change do
    create index(:aircall_calls, [:user_id])

    alter table(:users) do
      add :aircall_user_id, :integer
    end

    create table(:contacts) do
      add :aircall_contact_id, :integer
      add :first_name, :string
      add :last_name, :string
      add :origin, :string
      add :type, :string
      add :emails, {:array, :map}
      add :phone_numbers, {:array, :map}

      timestamps()
    end
  end
end
