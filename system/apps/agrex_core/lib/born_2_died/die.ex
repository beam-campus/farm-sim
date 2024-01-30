defmodule Agrex.Born2Died.Die.PayloadV1 do
  use Ecto.Schema

  @moduledoc """
  the payload for the edge:attached:v1 fact
  """
  @primary_key false
  embedded_schema do
    field(:life_id, :string)
    field(:age, :integer)

    field(:cause, Ecto.Enum,
      values: [
        :unknown,
        :starvation,
        :predation,
        :slaughtered,
        :old_age
      ]
    )
  end

  def new(life_id, age, cause \\ :unknown),
    do: %__MODULE__{
      life_id: life_id,
      age: age,
      cause: cause
    }
end
