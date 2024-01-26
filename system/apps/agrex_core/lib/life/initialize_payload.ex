defmodule Agrex.Life.Initialize.PayloadV1 do
  use Ecto.Schema

  

  @moduledoc """
  the payload for the edge:attached:v1 fact
  """
  @primary_key false
  embedded_schema do
    field(:life_id, :string)
  end

  def new(life_id),
    do: %__MODULE__{
      life_id: life_id
    }
end
