defmodule Agrex.Born2Died.MatePayloadV1 do
  use Ecto.Schema


  @moduledoc """
  the payload for the life:breed facts and hopes
  """

  @fact_v1 "life:mated:v1"
  @hope_v1 "life:mate:v1"

  def fact, do: @fact_v1
  def hope, do: @hope_v1

  @primary_key false
  embedded_schema do
    field(:life_id, :string)
    field(:partner_id, :string)
    field(:is_success, :boolean)
  end

  def new(life_id, partner_id, is_success),
    do: %__MODULE__{
      life_id: life_id,
      partner_id: partner_id,
      is_success: is_success
    }
end
