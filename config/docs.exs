use Mix.Config

config :atom_tweaks, AtomTweaks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "atom_tweaks_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
