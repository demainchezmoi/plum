defmodule Plum.Repo.Migrations.SalesProspects do
  use Ecto.Migration

  def change do
    # Prospect
    create table(:sales_prospects) do
      add :max_budget, :integer
      timestamps()
    end

    # Prospect cities
    create table(:sales_prospects_geo_cities, primary_key: false) do
      add :sales_prospect_id, references(:sales_prospects, on_delete: :delete_all)
      add :geo_city_id, references(:geo_cities, on_delete: :delete_all)
    end

    create index(:sales_prospects_geo_cities, [:sales_prospect_id])
    create index(:sales_prospects_geo_cities, [:geo_city_id])

    # Prospect lands
    create table(:sales_prospects_geo_lands) do
      add :land_id, references(:geo_lands, on_delete: :delete_all)
      add :prospect_id, references(:sales_prospects, on_delete: :delete_all)
      add :status, :string
      timestamps()
    end

    create index(:sales_prospects_geo_lands, [:land_id])
    create index(:sales_prospects_geo_lands, [:prospect_id])
  end
end
