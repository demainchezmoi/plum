defmodule Plum.Repo.Migrations.ProspectStatus do
  use Ecto.Migration

  def change do
    alter table(:sales_prospects) do
      add :status, :string
    end
  end
end
