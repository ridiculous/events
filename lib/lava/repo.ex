defmodule Lava.Repo do
  use Ecto.Repo,
    otp_app: :lava,
    adapter: Ecto.Adapters.Postgres
end
