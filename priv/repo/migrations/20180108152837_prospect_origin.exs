defmodule Plum.Repo.Migrations.ProspectOrigin do
  use Ecto.Migration

  def change do
    alter table(:sales_prospects) do
      add :origin, :string
    end
  end
end
