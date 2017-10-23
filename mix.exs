defmodule Plum.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plum,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Plum.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ecto_conditionals, "~> 0.1.0"},
      {:ex_machina, "~> 2.1", only: [:test]},
      {:gen_smtp, "~> 0.12.0"},
      {:gettext, "~> 0.11"},
      {:mix_docker, "~> 0.5.0"},
      {:mix_test_watch, "~> 0.3", only: [:test], runtime: false},
      {:mixpanel, "0.0.1"},
      {:number, "~> 0.5.4"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_swoosh, "~> 0.2"},
      {:postgrex, ">= 0.0.0"},
      {:secure_random, "~> 0.5"},
      {:smoothie, "~> 3.0"},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_facebook, "~> 0.7"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
