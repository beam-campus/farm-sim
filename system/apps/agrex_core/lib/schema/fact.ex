defmodule Agrex.Schema.Fact do
  use Ecto.Schema

  @moduledoc """
  Agrex.Schema.Fact is a data structure that represents Facts (Events) in the Agrex system.
  """

  alias Agrex.Schema.Meta

  @primary_key false
  embedded_schema do
    field(:topic, :string)
    embeds_one(:meta, Meta)
    embeds_one(:payload, :map)
  end

  def new(topic, meta, payload),
      do: %__MODULE__{
        topic: topic,
        meta: meta,
        payload: payload
      }

end
