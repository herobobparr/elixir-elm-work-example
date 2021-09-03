use Mix.Config

config :usd2rur,
  salt: "my_salt"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :usd2rur, Usd2rur.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :usd2rur, Usd2rur.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "usd2rur_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Config guarding
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MyApp",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "fake_key",
  serializer: Usd2rur.GuardianSerializer
