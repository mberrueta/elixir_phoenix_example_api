defmodule Imdb.Repo do
  use Ecto.Repo,
    otp_app: :imdb,
    adapter: Ecto.Adapters.Postgres
end
