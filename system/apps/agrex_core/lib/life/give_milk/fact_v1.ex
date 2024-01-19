defmodule Agrex.Life.Move.FactV1 do
  use Ecto.Schema

  @moduledoc """
  Agrex.Life.Move.Fact is a data structure that represents
  the fact that a life has moved.
  """
  alias Agrex.Schema.Meta
  alias Agrex.Life.Move.PayloadV1
  alias Agrex.Life.Move.Fact

  @fact_v1 "life:move:fact:v1"

  def fact_v1, do: @fact_v1

  @primary_key false
  embedded_schema do
    embeds_one(:meta, Meta)
    embeds_one(:payload, PayloadV1)
  end

  def new(
        life_id,
        order,
        correlation_id,
        causation_id,
        causation_type,
        vector,
        delta_t
      ),
      do: %__MODULE__{
        meta:
          Meta.new(
            @fact_v1,
            life_id,
            order,
            correlation_id,
            causation_id,
            causation_type
          ),
        payload:
          PayloadV1.new(
            life_id,
            vector,
            delta_t
          )
      }
end
