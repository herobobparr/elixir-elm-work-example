use Mix.Config


config :usd2rur,
  salt: System.get_env("SALT")

config :usd2rur, Usd2rur.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "usd2rur.heroku.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :info

# Configure your database
config :usd2rur, Usd2rur.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Config guarding
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MyApp",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: System.get_env("SECRET_KEY"),
  serializer: Usd2rur.GuardianSerializer
