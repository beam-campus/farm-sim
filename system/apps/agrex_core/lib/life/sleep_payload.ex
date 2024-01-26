defmodule Agrex.Life.Sleep.PayloadV1 do
  use Ecto.Schema


  @moduledoc """
  the payload for the edge:attached:v1 fact
  """
  @primary_key false
  embedded_schema do
    field(:life_id, :string)
    field(:delta_t, :integer)
  end

  def new(life_id, delta_t),
    do: %__MODULE__{
      life_id: life_id,
      delta_t: delta_t
    }
end
