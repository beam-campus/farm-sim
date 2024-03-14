defmodule Agrex.MngFarm.State do
  @moduledoc """
  Agrex.MngFarm.State is a GenServer that holds the state of a Farm.
  """
  use Ecto.Schema


  embedded_schema() do
    field(:aggregate_id, :string)
    embeds_one(:farm, Agrex.Schema.Farm)
  end


end
