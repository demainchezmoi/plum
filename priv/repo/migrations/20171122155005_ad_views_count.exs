defmodule Plum.Repo.Migrations.AdViewsCount do
  use Ecto.Migration

  def change do
    alter table(:ads) do
      add :view_count, :integer, default: 0
    end
  end
end
