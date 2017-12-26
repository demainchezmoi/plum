defmodule Plum.Repo.Migrations.CreateGeoCities do
  use Ecto.Migration

  def change do
    create table(:geo_cities) do
      add :name, :string
      add :postal_code, :string
      add :insee_id, :string

      timestamps()
    end

    create unique_index(:geo_cities, [:insee_id])
  end
end
