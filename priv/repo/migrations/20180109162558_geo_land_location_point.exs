defmodule Plum.Repo.Migrations.GeoLandLocationPoint do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE geo_lands ADD COLUMN location geography(Point,4326);")
  end

  def down do
    alter table(:geo_lands) do
      remove :location
    end
  end
end
