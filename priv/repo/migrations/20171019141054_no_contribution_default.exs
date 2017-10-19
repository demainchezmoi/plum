defmodule Plum.Repo.Migrations.NoContributionDefault do
  use Ecto.Migration

  def up do
    alter table(:projects) do
      modify :contribution, :integer, default: nil
    end
  end

  def down do
    alter table(:projects) do
      modify :contribution, :integer, default: 0
    end
  end
end
