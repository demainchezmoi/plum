defmodule Plum.Repo.Migrations.RemoveProject do
  use Ecto.Migration

  def change do
    drop table(:projects)
  end
end
