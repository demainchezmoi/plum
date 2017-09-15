defmodule Plum.Repo.Migrations.CreateAd do
  use Ecto.Migration

  def change do
    create table(:ads) do
      add :active, :boolean, default: true
      timestamps()
    end
  end
end
