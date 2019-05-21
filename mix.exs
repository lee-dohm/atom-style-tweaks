defmodule AtomTweaks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :atom_tweaks,
      version: "0.1.0",
      name: "Atom Tweaks",
      homepage_url: "https://www.atom-tweaks.com",
      source_url: "https://github.com/lee-dohm/atom-style-tweaks",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls, test_task: "test"],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],

      # Silence deprecation warning
      # See https://github.com/phoenixframework/phoenix/issues/2888 for details
      # Should be able to remove when upgrading to Plug v1.5.1 or above
      xref: [
        exclude: [AtomTweaksWeb.Router, {Plug.Conn.WrapperError, :reraise, 3}]
      ]
    ]
  end

  def application do
    [
      mod: {
        AtomTweaks.Application,
        []
      },
      applications: app_list(Mix.env())
    ]
  end

  defp app_list(:dev), do: [:dotenv | app_list()]
  defp app_list(_), do: app_list()

  defp app_list,
    do: [
      :phoenix,
      :phoenix_pubsub,
      :phoenix_html,
      :cowboy,
      :sentry,
      :ex_debug_toolbar,
      :logger,
      :gettext,
      :phoenix_ecto,
      :postgrex,
      :oauth2,
      :tzdata,
      :octicons
    ]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Full dependencies
      {:cmark, "~> 0.7"},
      {:ex_debug_toolbar, "~> 0.5"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:navigation_history, "~> 0.2"},
      {:oauth2, "~> 1.0.1"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_octicons, "~> 0.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_slime, "~> 0.12.0"},
      {:phoenix, "~> 1.4.6"},
      {:plug_cowboy, "~> 1.0"},
      {:plug_ribbon, "~> 0.2"},
      {:postgrex, ">= 0.0.0"},
      {:sentry, "~> 7.0.6"},
      {:timex, "~> 3.1"},

      # Dev dependencies
      {:credo, "~> 1.0.5", only: [:dev, :test], runtime: false},
      {:dotenv, "~> 3.0.0", only: :dev},
      {:ex_doc, "~> 0.16", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.0", only: :test},
      {:excoveralls, "~> 0.6", only: :test},
      {:faker_elixir_octopus, "~> 1.0", only: :test},
      {:floki, "~> 0.20.0", only: [:dev, :test]},
      {:html_entities, "~> 0.4.0", only: [:dev, :test]},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:uuid, "~> 1.1", only: [:dev, :test]}
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
      ],
      groups_for_modules: [
        Accounts: [
          ~r{^AtomTweaks\.Accounts}
        ],
        Controllers: [
          ~r{^AtomTweaks.*Controller$}
        ],
        "Ecto Types": [
          ~r{^AtomTweaks.Ecto.*}
        ],
        Helpers: [
          ~r{^AtomTweaks.*Helpers$}
        ],
        Localization: [
          AtomTweaksWeb.Gettext
        ],
        Markdown: [
          ~r{Markdown}
        ],
        Notes: [
          ~r{^AtomTweaks.Notes}
        ],
        OAuth: [
          AtomTweaksWeb.GitHub
        ],
        Plugs: [
          AtomTweaksWeb.HerokuMetadata,
          AtomTweaksWeb.PageMetadata,
          AtomTweaksWeb.SlidingSessionTimeout
        ],
        Primer: [
          ~r{^AtomTweaksWeb\.Primer}
        ],
        Sockets: [
          ~r{^AtomTweaksWeb.*Socket$}
        ],
        Test: [
          ~r{^AtomTweaks.*(Channel|Conn|Data)Case$},
          ~r{^AtomTweaks.Support},
          ~r{^Support}
        ],
        Tweaks: [
          ~r{^AtomTweaks\.Tweaks}
        ],
        Views: [
          ~r{^AtomTweaksWeb.*View$}
        ]
      ]
    ]
  end
end
