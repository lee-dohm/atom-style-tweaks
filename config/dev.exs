use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :atom_style_tweaks, AtomStyleTweaksWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

# Watch static and templates for browser reloading.
config :atom_style_tweaks, AtomStyleTweaksWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/atom_style_tweaks_web/views/.*(ex)$},
      ~r{lib/atom_style_tweaks_web/templates/.*(eex|slim|slime)$}
    ]
  ]

# Timeout sessions in one minute in the development environment
config :atom_style_tweaks, AtomStyleTweaksWeb.SlidingSessionTimeout,
  timeout: 60

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Uncomment the following line to make stacktraces in templates easier to follow
# config :slime, :keep_lines, true

# Configure your database
config :atom_style_tweaks, AtomStyleTweaks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "atom_style_tweaks_dev",
  hostname: "localhost",
  pool_size: 10

config :ex_doc, :markdown_processor, ExDoc.Markdown.Cmark
