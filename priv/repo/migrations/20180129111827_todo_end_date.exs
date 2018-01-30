defmodule Plum.Repo.Migrations.TodoEndDate do
  use Ecto.Migration

  def change do
    alter table(:sales_todos) do
      add :end_date, :date
    end
  end
end
