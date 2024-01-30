defmodule Agrex.MngHerd.State do
  use Ecto.Schema
  import Agrex.Limits
  alias Agrex.Schema.Id

  @moduledoc """
  Documentation for `Agrex.MngHerd.State`.
  """

  @prefix "herd"

  @primary_key false
  embedded_schema do
    field :id, :string
    field :edge_id, :string
    field :size, :integer
    embeds_one(:map, Agrex.Schema.Vector)
  end

  def random(edge_id, map) do
    %Agrex.MngHerd.State{
      id: Id.new(@prefix) |> Id.as_string(),
      edge_id: edge_id,
      size: random_nbr_lives(),
      map: map
    }
  end
  
end
