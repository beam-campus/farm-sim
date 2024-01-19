defmodule Agrex.Life.Breed.FactV1 do
  use Ecto.Schema

  @moduledoc """
  Agrex.Life.Breed.Fact is a data structure that represents
  the fact that a life has Breeded.
  """
  alias Agrex.Schema.Meta
  alias Agrex.Life.Breed.PayloadV1
  alias Agrex.Life.Breed.Fact

  @fact_v1 "life:breed:fact:v1"

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
        partner_id,
        is_success
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
            partner_id,
            is_success
          )
      }
end
