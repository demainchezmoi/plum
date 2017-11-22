defmodule Plum.Repo.Migrations.AdaptationFees do
  use Ecto.Migration

  def change do
    alter table(:ads) do
      add :adaptation_fees, :integer
    end
  end
end
