defmodule Plum.Repo.Migrations.SalesTodos do
  use Ecto.Migration

  def change do
    create table(:sales_todos) do
      add :done, :boolean
      add :priority, :integer
      add :start_date, :date 
      add :title, :string
      add :prospect_id, references(:sales_prospects, on_delete: :delete_all)
      timestamps()
    end
  end
end
