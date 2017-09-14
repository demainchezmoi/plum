defmodule Plum.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    create table(:contact) do
      add :email, :string
      add :phone, :string
      add :name, :string

      timestamps()
    end

  end
end
