use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :atom_tweaks, AtomTweaksWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--watch-stdin",
      "--progress",
      "--color",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :atom_tweaks, AtomTweaksWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|jsx|ts|tsx|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/atom_tweaks_web/views/.*(ex)$},
      ~r{lib/atom_tweaks_web/templates/.*(eex|slim|slime)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Uncomment the following line to make stacktraces in templates easier to follow
# config :slime, :keep_lines, true

# Configure your database
config :atom_tweaks, AtomTweaks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "atom_tweaks_dev",
  hostname: "localhost",
  pool_size: 10

config :ex_doc, :markdown_processor, ExDoc.Markdown.Cmark

# ExDebugToolbar config
config :ex_debug_toolbar,
  enable: true

config :atom_tweaks, AtomTweaksWeb.Endpoint,
  instrumenters: [ExDebugToolbar.Collector.InstrumentationCollector]

config :atom_tweaks, AtomTweaks.Repo,
  loggers: [ExDebugToolbar.Collector.EctoCollector, Ecto.LogEntry]

config :phoenix, :template_engines,
  eex: ExDebugToolbar.Template.EExEngine,
  exs: ExDebugToolbar.Template.ExsEngine,
  slim: ExDebugToolbar.Template.SlimEngine,
  slime: ExDebugToolbar.Template.SlimEngine
