# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :plum,
  ecto_repos: [Plum.Repo]

# Configures the endpoint
config :plum, PlumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/0b5qNMRxH0qlj9Lcz2yqZ179YS6Vf62dX6K6LeNCwOmdayp0IRCFTLZ93xlZsni",
  render_errors: [view: PlumWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Plum.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mix_docker, image: "383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :plum, session_key: "session_auth"

config :number, delimit: [
  precision: 2,
  delimiter: "&nbsp;",
  separator: ","
]

config :number, currency: [
  unit: "€",
  precision: 0,
  delimiter: "&nbsp;",
  separator: ",",
  format: "%n&nbsp;%u",
  negative_format: "%n&nbsp;%u" # "(£30.00)"
]
