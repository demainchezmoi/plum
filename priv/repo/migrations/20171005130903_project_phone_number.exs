defmodule Plum.Repo.Migrations.ProjectPhoneNumber do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :phone_number, :string
    end
  end
end
