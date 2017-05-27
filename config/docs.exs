use Mix.Config

config :atom_style_tweaks, AtomStyleTweaks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "atom_style_tweaks_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
