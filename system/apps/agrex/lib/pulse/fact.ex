defmodule Agrex.Pulse.Fact do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :timestamp, :utc_datetime
  end
end
