defmodule Plum.Repo.Migrations.ProspectCostsFields do
  use Ecto.Migration

  def change do
    alter table(:sales_prospects) do
      add :house_price, :integer, default: 0
      add :garage_price, :integer, default: 0
      add :kitchen_price, :integer, default: 5000
      add :soil_price, :integer, default: 0
      add :walls_ceiling_price, :integer, default: 0
      add :terrace_price, :integer, default: 0
    end
  end
end
