defmodule AtomStyleTweaks.Mixfile do
  use Mix.Project

  @version String.trim(File.read!("VERSION"))

  def project do
    [
      app: :atom_style_tweaks,
      version: @version,
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.html": :test]
    ]
  end

  def application do
    [
      mod: {
        AtomStyleTweaks,
        []
      },
      applications: app_list(Mix.env)
    ]
  end

  defp app_list(:dev), do: [:dotenv | app_list()]
  defp app_list(_), do: app_list()
  defp app_list, do: [
    :phoenix,
    :phoenix_pubsub,
    :phoenix_html,
    :cowboy,
    :logger,
    :gettext,
    :phoenix_ecto,
    :postgrex,
    :oauth2,
    :tzdata
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:cmark, "~> 0.7"},
      {:cowboy, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:oauth2, "~> 0.8.2"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_slime, "~> 0.8.0"},
      {:phoenix, "~> 1.2.4"},
      {:postgrex, ">= 0.0.0"},
      {:timex, "~> 3.1"},
      {:dotenv, "~> 2.0.0", only: :dev},
      {:ex_doc, "~> 0.14.5", only: :dev},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:credo, "0.8.0-rc6", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.0", only: :test},
      {:faker_elixir_octopus, "~> 1.0", only: :test},
      {:html_entities, "~> 0.3.0", only: :test},
      {:floki, "~> 0.17.2", only: :test},
      {:excoveralls, "~> 0.6", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.ci": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["credo", "test"]
    ]
  end

  defp docs do
    [
      extras: ["README.md", "LICENSE.md", "CODE_OF_CONDUCT.md"]
    ]
  end
end
