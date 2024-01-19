defmodule Agrex.Life.Move.HopeV1 do
  use Ecto.Schema

  @moduledoc """
  Agrex.Life.Move.Hope is a data structure that represents
  the hope that a life will move.
  """
  alias Agrex.Schema.Meta
  alias Agrex.Life.Move.PayloadV1
  alias Agrex.Life.Move.Hope

  @hope_v1 "life:move:hope:v1"

  def hope_v1, do: @hope_v1

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
            @topic_v1,
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
