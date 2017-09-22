defmodule AtomStyleTweaks.Mixfile do
  use Mix.Project

  @version String.trim(File.read!("VERSION"))

  def project do
    [
      app: :atom_style_tweaks,
      version: @version,

      name: "Atom Tweaks",
      homepage_url: "https://www.atom-tweaks.com",
      source_url: "https://github.com/lee-dohm/atom-style-tweaks",

      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.html": :test, "coveralls.travis": :test]
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
    :tzdata,
    :octicons,
    :rollbax
  ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:cmark, "~> 0.7"},
      {:cowboy, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:oauth2, "~> 0.8.2"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_slime, "~> 0.9.0"},
      {:phoenix, "~> 1.3.0"},
      {:postgrex, ">= 0.0.0"},
      {:rollbax, "~> 0.6"},
      {:timex, "~> 3.1"},
      {:phoenix_octicons, "~> 0.2.0"},
      {:dotenv, "~> 2.0.0", only: :dev},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
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
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "CODE_OF_CONDUCT.md",
        "CONTRIBUTING.md",
        "README.md": [
          filename: "readme",
          title: "README"
        ],
        "LICENSE.md": [
          filename: "license",
          title: "License"
        ]
      ]
    ]
  end
end
