defmodule Plum.Repo.Migrations.GeoLandAdContact do
  use Ecto.Migration

  def change do
    alter table(:geo_land_ads) do
      add :contact, :map
    end
  end
end
