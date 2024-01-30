defmodule Agrex.Born2Died.Initialize do
  @moduledoc """
  Agrex.Born2Died.Initialize is the worker process that is spawned for each Life.
  """

  ################ INTERFACE ###############
  @fact_v1 "agrex.Born2Died.initialized.v1"
  @hope_v1 "agrex.Born2Died.initialize.v1"

  def fact_v1(),
    do: @fact_v1

  def hope_v1(),
    do: @hope_v1

  ################ PAYLOAD ################
  defmodule PayloadV1 do
    use Ecto.Schema

    @moduledoc """
    the payload for the edge:attached:v1 fact
    """
    @primary_key false
    embedded_schema do
      field(:edge_id, :string)
      embeds_one(:pos, Agrex.Schema.Vector)
      embeds_one(:life, Agrex.Schema.Life)
    end

    def new(edge_id, pos, life),
      do: %__MODULE__{
        edge_id: edge_id,
        pos: pos,
        life: life
      }
  end
end
