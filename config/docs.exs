use Mix.Config

config :atom_style_tweaks, AtomTweaks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "atom_style_tweaks_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
