defmodule MilkToAnalyse.CaptureLife.Evt do
  use Ecto.Schema
  alias Agrex.Schema.MetaData
  alias MilkToAnalyse.CaptureLife.Payload

  @primary_key false
  embedded_schema do
    field(:agg_id, :string)
    embeds_one(:payload, Payload)
    embeds_one(:meta, MetaData)
  end

  def as_fact(%MilkToAnalyse.CaptureLife.Evt{} = event),
    do: Map.from_struct(event)
    
end
