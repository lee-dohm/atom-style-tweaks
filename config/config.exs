# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :atom_tweaks,
  author_name: "Lee Dohm",
  author_url: "https://www.lee-dohm.com",
  ecto_repos: [AtomTweaks.Repo],
  site_name: "Atom Tweaks"

# Configures the endpoint
config :atom_tweaks, AtomTweaksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NmI5A1GsVl5vf6o3m3+7/3NoWleK8mK6cG0cR2X6cyrrdlokEwRTfpE9H8vk0NoP",
  render_errors: [view: AtomTweaksWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AtomTweaksWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configure GitHub OAuth2 strategy
config :atom_tweaks, AtomTweaksWeb.GitHub, scope: "read:org"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Phoenix Generators
config :phoenix, :generators, binary_id: true

# Configure Phoenix template engines
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :slime, :embedded_engines, %{
  markdown: AtomTweaksWeb.MarkdownEngine
}

# Error tracking service
config :sentry,
  dsn: "https://c0a79cd8641c4dca94dc88ca74c92baf@sentry.io/1218568",
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  included_environments: [:staging, :prod]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
