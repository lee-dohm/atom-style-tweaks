use Mix.Config

# Base the staging configuration on prod
import_config "prod.exs"

config :atom_tweaks, AtomTweaksWeb.Endpoint,
  url: [host: "atom-tweaks-staging.herokuapp.com", port: 80]

config :sentry,
  tags: %{
    env: "staging"
  }
