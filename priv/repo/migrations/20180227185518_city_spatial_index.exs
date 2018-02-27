defmodule Plum.Repo.Migrations.CitySpatialIndex do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX geo_cities_location_gist ON geo_cities USING GIST (location);"
  end

  def down do
    execute "DROP INDEX geo_cities_location_gist;"
  end
end
