defmodule Plum.Repo.Migrations.LandInfos do
  use Ecto.Migration

  def change do
    alter table(:lands) do
      add :description, :text, default: ""
      add :images, {:array, :string}, default: []
    end
  end
end
