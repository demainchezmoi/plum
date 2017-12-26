defmodule Plum.Repo.Migrations.CreateGeoLandAds do
  use Ecto.Migration

  def change do
    create table(:geo_land_ads) do
      add :link, :string
      add :origin, :string
      add :land_id, references(:geo_lands, on_delete: :nothing)

      timestamps()
    end

    create index(:geo_land_ads, [:land_id])
    create index(:geo_land_ads, [:origin, :link])
  end
end
