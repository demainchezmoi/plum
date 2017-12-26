defmodule Plum.Repo.Migrations.CityIndexes do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX geo_cities_name_trgm_index ON geo_cities USING gin (name gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX geo_cities_name_trgm_index;"
  end
end
