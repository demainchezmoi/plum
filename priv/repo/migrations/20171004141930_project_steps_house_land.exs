defmodule Plum.Repo.Migrations.ProjectStepsHouseLand do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :discover_land, :boolean, default: false
      add :discover_house, :boolean, default: false
    end
  end
end
