use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plum, PlumWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :plum, Plum.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "plum_test",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :coherence, PlumWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Test

config :plum, PlumWeb.Mailer,
  adapter: Swoosh.Adapters.Test

