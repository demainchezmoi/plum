defmodule Plum.Repo.Migrations.RemoveLandLocation do
  use Ecto.Migration

  def change do
    alter table(:geo_lands) do
      remove :location
    end
  end
end
