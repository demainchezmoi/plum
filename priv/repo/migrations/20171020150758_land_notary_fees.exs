defmodule Plum.Repo.Migrations.LandNotaryFees do
  use Ecto.Migration

  def change do
    alter table(:lands) do
      add :notary_fees, :integer
    end
  end
end
