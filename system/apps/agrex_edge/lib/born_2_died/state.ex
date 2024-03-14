defmodule Agrex.Born2Died.State do
  @moduledoc """
  The Life State are the parameters
  that are used as the state structure for a Life Worker
  """
  use Ecto.Schema
  alias Agrex.Schema.Id

  defguard is_born_2_died_state(state) when is_struct(state, __MODULE__)

  @id_prefix "born2died"

  @status %{
    unknown: 0,
    initialized: 1,
    alive: 2,
    infected: 4,
    pregnant: 8,
    dead: 16,
    in_heat: 32,
    in_cool: 64,
    wounded: 128
  }

  def status, do: @status

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:field_id, :string)
    field(:ticks, :integer)
    field(:status, :integer)
    embeds_one(:life, Agrex.Schema.Life)
    embeds_one(:pos, Agrex.Schema.Vector)
    embeds_one(:vitals, Agrex.Schema.Vitals)
  end

  def random(edge_id, %{x: max_x, y: max_y, z: z} = _vector, life) do
    %Agrex.Born2Died.State{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: edge_id,
      field_id: Id.new("field", to_string(z)) |> Id.as_string(),
      life: life,
      pos: Agrex.Schema.Position.random(max_x, max_y),
      vitals: Agrex.Schema.Vitals.random(),
      ticks: 0,
      status: 0
    }
  end

  def default() do
    %Agrex.Born2Died.State{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: Agrex.Core.constants()[:edge_id],
      field_id: Id.new("field", to_string(1)) |> Id.as_string(),
      life: Agrex.Schema.Life.random(),
      pos: Agrex.Schema.Position.random(1_000, 1_000),
      vitals: Agrex.Schema.Vitals.random(),
      ticks: 0,
      status: 0
    }
  end

  def from_life(life) do
    %Agrex.Born2Died.State{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: Agrex.Core.constants()[:edge_id],
      field_id: Id.new("field", to_string(1)) |> Id.as_string(),
      life: life,
      pos: Agrex.Schema.Position.random(1_000, 1_000),
      vitals: Agrex.Schema.Vitals.random(),
      ticks: 0,
      status: 0
    }
  end



  ############## IMPLEMENTATIONS ##############
  defimpl String.Chars, for: __MODULE__ do
    def to_string(s) do
      "\n\n [#{__MODULE__}]\n" <>
        "#{s.life}" <>
        "#{s.vitals}\n\n"
    end
  end
end
