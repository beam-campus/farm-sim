defmodule Agrex.Born2Died.Calve do
  @moduledoc """
  the payload for the edge:attached:v1 fact
  """
  ################# TOPICS #################
  @fact_v1 "agrex.Born2Died.calved.v1"
  @hope_v1 "agrex.Born2Died.calve.v1"

  def fact_v1(),
    do: @fact_v1

  def hope_v1(),
    do: @hope_v1

  ################ PAYLOAD ################
  defmodule Payload do
    @moduledoc """
    the payload for the edge:attached:v1 fact
    """
    use Ecto.Schema
    alias Agrex.Schema.Life

    @primary_key false
    embedded_schema do
      field(:life_id, :string)
      field(:birth_time, :utc_datetime_usec)
      embeds_one(:offspring, Life)
    end

    def new(life_id, birth_time, offspring),
      do: %__MODULE__{
        life_id: life_id,
        birth_time: birth_time,
        offspring: offspring
      }
  end
end
