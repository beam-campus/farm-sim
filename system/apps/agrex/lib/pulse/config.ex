defmodule Agrex.Pulse.Config do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :domain, :string
    field :period_ms, :integer
  end
end
