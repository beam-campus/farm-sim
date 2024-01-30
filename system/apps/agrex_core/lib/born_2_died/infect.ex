defmodule Agrex.Born2Died.Infect.PayloadV1 do
  use Ecto.Schema

  @moduledoc """
  the payload for the edge:attached:v1 fact
  """
  @primary_key false
  embedded_schema do
    field(:life_id, :string)
    field(:rate, :integer)
  end

  def new(life_id, rate),
    do: %__MODULE__{
      life_id: life_id,
      rate: rate
    }
end
