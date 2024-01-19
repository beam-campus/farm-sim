defmodule Agrex.Life.Breed.PayloadV1 do
  use Ecto.Schema

  alias Agrex.Schema.Vector

  @moduledoc """
  the payload for the life:breed facts and hopes
  """
  @primary_key false
  embedded_schema do
    field(:life_id, :string)
    field(:partner_id, :string)
    field(:is_success, :boolean)
  end

  def new(life_id, partner_id, is_succe),
    do: %__MODULE__{
      life_id: life_id,
      partner_id: partner_id,
      is_success: is_success
    }
end
