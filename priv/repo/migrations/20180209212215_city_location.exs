defmodule Plum.Repo.Migrations.CityLocation do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE geo_cities ADD COLUMN location geography(Point,4326);")
  end

  def down do
    alter table(:geo_cities) do
      remove :location
    end
  end
end
