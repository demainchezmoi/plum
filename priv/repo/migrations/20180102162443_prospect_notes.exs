defmodule Plum.Repo.Migrations.ProspectNotes do
  use Ecto.Migration

  def change do
    alter table(:sales_prospects) do
      add :notes, :text
    end
  end
end
