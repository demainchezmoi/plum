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
  pool: Ecto.Adapters.SQL.Sandbox,
  types: Plum.PostgresTypes

config :plum, PlumWeb.Mailer,
  adapter: Swoosh.Adapters.Test

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "eu-west-1",
  s3: [
    scheme: "https://",
    host: "s3-eu-west-1.amazonaws.com",
    region: "eu-west-1"
  ]

config :plum,
  env: "dev"
