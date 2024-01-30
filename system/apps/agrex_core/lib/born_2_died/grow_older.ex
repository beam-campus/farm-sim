defmodule Agrex.Born2Died.GrowOlder do
  @moduledoc """
  Agrex.Born2Died.GrowOlder is the worker process that is spawned for each Life.
  """

  @fact_v1 "agrex.Born2Died.aged.v1"
  @hope_v1 "agrex.Born2Died.age.v1"

  def fact_v1(),
    do: @fact_v1

  def hope_v1(),
    do: @hope_v1

  defmodule PayloadV1 do
    use Ecto.Schema

    @moduledoc """
    the payload for the edge:attached:v1 fact
    """
    @primary_key false
    embedded_schema do
      field(:life_id, :string)
      field(:age, :integer)
    end

    def new(life_id, age),
      do: %__MODULE__{
        life_id: life_id,
        age: age
      }
  end


end
