defmodule Agrex.Life.State do
  use Ecto.Schema

  @moduledoc """
  The Life State are the parameters
  that are used as the state structure for a Life Worker
  """

  alias Agrex.Schema.Id

  @primary_key false
  embedded_schema do
    field :edge_id, :string
    field :field_id, :string
    embeds_one :life, Agrex.Schema.Life
    embeds_one :pos, Agrex.Schema.Vector
    embeds_one :vitals, Agrex.Schema.Vitals
    field :ticks, :integer
    field :status, Ecto.Enum,
      values: [:unknown, :born, :alive, :dead],
      default: :unknown
  end

  def random(edge_id, %{x: x, y: y, z: z} = _vector, life) do
    %Agrex.Life.State{
      edge_id: edge_id,
      field_id: Id.new("field", to_string(z)) |> Id.as_string(),
      life: life,
      pos: Agrex.Schema.Position.random(x, y),
      vitals: Agrex.Schema.Vitals.random(),
      ticks: 0
    }
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(s) do
      "\n\n [#{__MODULE__}]"
      "#{s.life}" <>
      "#{s.vitals}"
    end
  end

end
