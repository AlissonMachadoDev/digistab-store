defmodule DigistabStore.Repo do
  use Ecto.Repo,
    otp_app: :digistab_store,
    adapter: Ecto.Adapters.Postgres
end
