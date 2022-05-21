# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :etherscan, EtherscanWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: EtherscanWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Etherscan.PubSub,
  live_view: [signing_salt: "Zo7djWzg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :etherscan,
  blocknative_api: "https://api.blocknative.com/transaction",
  blocknative_key: System.get_env("BLOCKNATIVE_KEY"),
  slack_api: "https://hooks.slack.com/services/T03GBSVGA0M/B03H4HE40KA",
  slack_key: System.get_env("SLACK_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
