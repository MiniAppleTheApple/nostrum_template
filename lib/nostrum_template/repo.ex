defmodule NostrumTemplate.Repo do
  use Ecto.Repo,
    otp_app: :nostrum_template,
    adapter: Ecto.Adapters.Postgres
end
