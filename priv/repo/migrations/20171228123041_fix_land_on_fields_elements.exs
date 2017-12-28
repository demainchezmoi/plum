defmodule Plum.Repo.Migrations.FixLandOnFieldsElements do
  use Ecto.Migration

  def change do
    alter table(:geo_lands) do
      remove :on_add_elements
      add :on_field_elements, :string
    end
  end
end
