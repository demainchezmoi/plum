defmodule Plum.Repo.Migrations.CreateAd do
  use Ecto.Migration

  def change do
    create table(:ad) do
      add :land_surface, :integer
      add :land_price, :integer
      add :land_lat, :float
      add :land_lng, :float

      timestamps()
    end

  end
end
