defmodule Agrex.Life.Move.PayloadV1 do
  use Ecto.Schema

  alias Agrex.Schema.Vector

  @moduledoc """
  the payload for the edge:attached:v1 fact
  """
  @primary_key false
  embedded_schema do
    field(:life_id, :string)
    embeds_one(:vector, Vector)
    field(:delta_t, :integer)
  end

  def new(life_id, vector, delta_t),
    do: %__MODULE__{
      life_id: life_id,
      vector: vector,
      delta_t: delta_t
    }
end
