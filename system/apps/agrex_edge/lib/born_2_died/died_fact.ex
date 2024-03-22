defmodule Agrex.Born2Died.DiedFact do
  use Ecto.Schema

  @moduledoc """
  Life.DiedFact is a fact that is emitted when a Life dies.
  """

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:topic, :string, default: "life.died.v1")
    field(:type, :string, default: "died")
    field(:meta, :map)
    embeds_one(:state, Agrex.Born2Died.State)
  end

  def new(state) do
    %__MODULE__{
      id: Agrex.Schema.Id.new("died") |> Agrex.Schema.Id.as_string(),
      state: state
    }
  end
end
