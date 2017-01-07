# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :atom_style_tweaks,
  ecto_repos: [AtomStyleTweaks.Repo]

# Configures the endpoint
config :atom_style_tweaks, AtomStyleTweaks.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NmI5A1GsVl5vf6o3m3+7/3NoWleK8mK6cG0cR2X6cyrrdlokEwRTfpE9H8vk0NoP",
  render_errors: [view: AtomStyleTweaks.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AtomStyleTweaks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure GitHub OAuth2 parameters
config :atom_style_tweaks, GitHub,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

# Configure Phoenix Generators
config :phoenix, :generators,
  binary_id: true

# Configure Phoenix template engines
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
