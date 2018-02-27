defmodule Plum.Repo.Migrations.CityDepartment do
  use Ecto.Migration

  def change do
    alter table(:geo_cities) do
      add :department, :string
    end
  end
end
