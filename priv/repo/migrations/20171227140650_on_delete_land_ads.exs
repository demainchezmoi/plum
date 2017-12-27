defmodule Plum.Repo.Migrations.OnDeleteLandAds do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE geo_land_ads DROP CONSTRAINT geo_land_ads_land_id_fkey"
    alter table(:geo_land_ads) do
      modify :land_id, references(:geo_lands, on_delete: :delete_all)
    end
  end
end
