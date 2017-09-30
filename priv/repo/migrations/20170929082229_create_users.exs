defmodule Plum.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :admin, :boolean, default: false, null: false
      add :facebook_id, :string
      add :roles, {:array, :string}

      timestamps()
    end
    create unique_index(:users, [:email])
  end
end
