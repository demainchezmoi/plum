defmodule Plum.Repo.Migrations.GeoLandAdditionalFields do
  use Ecto.Migration

  def change do
    alter table(:geo_lands) do
      add :address, :string
      add :land_register_ref, :string
      add :serviced, :boolean
      add :slope, :string
      add :type, :string
      add :soc, :float
      add :on_add_elements, :string
      add :accessibility, :string
      add :sanitation, :string
      add :environment, :string
      add :geoportail, :string
      add :googlemaps, :string
      add :openstreetmaps, :string
    end
  end
end
