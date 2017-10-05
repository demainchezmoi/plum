defmodule Plum.Repo.Migrations.ProjectStepInfos do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :house_color_1, :string
      add :house_color_2, :string
      add :contribution, :integer, default: 0
      add :net_income, :integer
      add :phone_call, :boolean, default: false
    end
  end
end
