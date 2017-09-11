defmodule Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:plum)

    path = Application.app_dir(:plum, "priv/repo/migrations")

    Ecto.Migrator.run(Plum.Repo, path, :up, all: true)
  end
end
