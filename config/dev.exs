use Mix.Config

config :usd2rur,
  salt: "my_salt"
# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :usd2rur, Usd2rur.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [npm: [ "start",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :usd2rur, Usd2rur.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :usd2rur, Usd2rur.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "usd2rur_dev",
  hostname: "localhost",
  pool_size: 10


# Config guarding
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MyApp",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "9Aijw2cDOKvf2wb/mQk1r7riOrzLt5g8lEnCC0p9aWr6EzYrqT+cvA2I+41+6ekuSVk2W8Rs8Yi10JaI77VP1g==",
  serializer: Usd2rur.GuardianSerializer
