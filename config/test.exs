use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :atom_tweaks, AtomTweaksWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :atom_tweaks, AtomTweaks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "atom_tweaks_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Customize the test environment for CI systems
if System.get_env("CI") == "true", do: import_config "ci.exs"
