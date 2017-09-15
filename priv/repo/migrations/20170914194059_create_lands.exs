defmodule Plum.Repo.Migrations.CreateLands do
  use Ecto.Migration

  def change do
    create table(:lands) do
      add :surface, :integer
      add :lat, :float
      add :lng, :float
      add :price, :integer
      add :city, :string
      add :department, :string
      add :active, :boolean, default: true

      timestamps()
    end
  end
end
