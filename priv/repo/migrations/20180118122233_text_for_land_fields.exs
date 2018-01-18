defmodule Plum.Repo.Migrations.TextForLandFields do
  use Ecto.Migration

  def change do
    alter table(:geo_lands) do
      modify :images, {:array, :text}
      modify :description, :text
      modify :address, :text
      modify :on_field_elements, :text
      modify :accessibility, :text
      modify :environment, :text
    end

    alter table(:geo_land_ads) do
      modify :link, :text
    end
  end
end
