defmodule Plum.Repo.Migrations.LandLocation do
  use Ecto.Migration

  def change do
    alter table(:lands) do
      remove :lat
      remove :lng
      add :location, :map
    end
  end
end
