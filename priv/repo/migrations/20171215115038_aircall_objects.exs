defmodule Plum.Repo.Migrations.AircallObjects do

  use Ecto.Migration

  def change do
    create table(:aircall_calls) do
      add :direct_link, :string
      add :status, :string
      add :direction, :string
      add :started_at, :integer
      add :answered_at, :integer
      add :ended_at, :integer
      add :duration, :integer
      add :raw_digits, :string
      add :voicemail, :string
      add :recording, :string
      add :archived, :boolean
      add :missed_call_reason, :string

      add :number_id, references(:aircall_numbers, on_delete: :nilify_all)
      add :user_id, references(:aircall_users, on_delete: :nilify_all)
      add :contact_id, references(:aircall_contacts, on_delete: :nilify_all)
      add :assigned_to_id, references(:aircall_users, on_delete: :nilify_all)

      add :comments, {:array, :map}
      add :tags, {:array, :map}
    end

    create table(:aircall_contacts) do
      add :direct_link, :string
      add :first_name, :string
      add :last_name, :string
      add :company_name, :string
      add :information, :string
      add :phone_numbers, {:array, :map}
      add :emails, {:array, :map}
    end

    create table(:aircall_numbers) do
		  add :direct_link, :string
		  add :name, :string
		  add :digits, :string
		  add :country, :string
		  add :time_zone, :string
		  add :open, :boolean
		  add :availability_status, :string
		  add :is_ivr, :boolean
      add :messages, :map
    end

    create table(:aircall_users) do
      add :direct_link, :string
      add :name, :string
      add :email, :string
      add :available, :boolean
      add :availability_status, :string
    end

    create table(:aircall_users_aircall_numbers, primary_key: false) do
      add :aircall_user_id, references(:aircall_users, on_delete: :delete_all)
      add :aircall_number_id, references(:aircall_numbers, on_delete: :delete_all)
    end

    create index(:aircall_users_aircall_numbers, [:aircall_user_id])
    create index(:aircall_users_aircall_numbers, [:aircall_number_id])
end
