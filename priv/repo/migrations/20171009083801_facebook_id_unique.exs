defmodule Plum.Repo.Migrations.FacebookIdUnique do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:facebook_id])
  end
end
