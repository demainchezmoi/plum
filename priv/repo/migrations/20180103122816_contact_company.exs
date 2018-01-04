defmodule Plum.Repo.Migrations.ContactCompany do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :company, :string
    end
  end
end
