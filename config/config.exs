# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello,
  ecto_repos: [Hello.Repo]

# config :hound, driver: "phantomjs"
config :hound, driver: "chrome_driver"
config :hound, retry_time: 1000

config :guardian, Guardian,
  issuer: "PhoenixTrello",
  ttl: { 3, :days },
  verify_issuer: true,
  secret_key: "PxvnraXUKMgIeKotV9OFRHuDEujM6pBf/I0rRcxfP7aHfOInGbpn2LpnqBe01v+d",
  serializer: PhoenixTrello.GuardianSerializer

# Configures the endpoint
config :hello, HelloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NBwY9lIn8XMp01bOtJwJS7qW8JGOnnhLQy5gM3ZPkWaLd8y8OLhwm6Rh9Mq+n2QM",
  render_errors: [view: HelloWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hello.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
