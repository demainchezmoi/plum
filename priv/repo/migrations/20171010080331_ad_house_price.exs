defmodule Plum.Repo.Migrations.AdHousePrice do
  use Ecto.Migration

  def change do
    alter table(:ads) do
      add :house_price, :integer
      add :land_adaptation_price, :integer
    end
  end
end
