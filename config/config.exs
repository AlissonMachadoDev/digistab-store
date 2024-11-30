# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :digistab_store,
  ecto_repos: [DigistabStore.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :digistab_store, DigistabStoreWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DigistabStoreWeb.ErrorHTML, json: DigistabStoreWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: DigistabStore.PubSub,
  live_view: [signing_salt: "h4ST/nc2"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :digistab_store, DigistabStore.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  digistab_store: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  digistab_store: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :digistab_store,
  bucket: System.get_env("AWS_BUCKET_NAME"),
  region: System.get_env("AWS_REGION"),
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")

config :money,
  # this allows you to do Money.new(100)
  default_currency: :BRL,
  # change the default thousands separator for Money.to_string
  separator: ".",
  # change the default decimal delimiter for Money.to_string
  delimiter: ",",
  # don’t display the currency symbol in Money.to_string
  symbol: false,
  # position the symbol
  symbol_on_right: false,
  # add a space between symbol and number
  symbol_space: false,
  # display units after the delimiter
  fractional_unit: true,
  # don’t display the insignificant zeros or the delimiter
  strip_insignificant_zeros: false,
  # add the currency code after the number
  code: false,
  # display the minus sign before the currency symbol for Money.to_string
  minus_sign_first: true,
  # don't display the delimiter or fractional units if the fractional units are only insignificant zeros
  strip_insignificant_fractional_unit: false
