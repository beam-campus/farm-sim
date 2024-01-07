defmodule Agrex.Repo do
  use Ecto.Repo,
    otp_app: :agrex,
    adapter: Ecto.Adapters.SQLite3
end
