defmodule Agrex.Schema.Fact do
  @moduledoc """
  Agrex.Schema.Fact is a data structure that represents Facts (Events) in the Agrex system.
  """
  use Ecto.Schema
  alias Agrex.Schema.Meta

  defguard is_fact(fact) when is_struct(fact, __MODULE__)

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
