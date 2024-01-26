defmodule Agrex.Life.Fight.PayloadV1 do
  use Ecto.Schema

  @moduledoc """
  the payload for the edge:attached:v1 fact
  """
  @primary_key false
  embedded_schema do
    field(:life_id, :string)
    field(:adversary_id, :string)
    field(:power, :integer)
  end

  def new(life_id, adversary_id, power),
    do: %__MODULE__{
      life_id: life_id,
      adversary_id: adversary_id,
      power: power
    }
end
