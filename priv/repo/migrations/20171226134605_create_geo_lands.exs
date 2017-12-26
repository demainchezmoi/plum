defmodule Plum.Repo.Migrations.CreateGeoLands do
  use Ecto.Migration

  def change do
    create table(:geo_lands) do
      add :surface, :integer
      add :price, :integer
      add :description, :text
      add :images, {:array, :string}
      add :notary_fees, :integer
      add :location, :map
      add :city_id, references(:geo_cities, on_delete: :nothing)

      timestamps()
    end

    create index(:geo_lands, [:city_id])
  end
end
