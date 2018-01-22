defmodule Plum.Repo.Migrations.LandFees do
  use Ecto.Migration

  def change do
    alter table(:geo_lands) do
      add :agency_fees, :integer, default: 0
      add :connection_fees, :integer, default: 0
      add :sanitation_fees, :integer, default: 0
      add :servicing_fees, :integer, default: 0
      add :demolition_fees, :integer, default: 0
    end
  end
end
