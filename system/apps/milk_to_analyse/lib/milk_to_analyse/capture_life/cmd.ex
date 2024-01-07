defmodule MilkToAnalyse.CaptureLife.Cmd do
  use Ecto.Schema

  alias Agrex.Schema.MetaData
  alias MilkToAnalyse.CaptureLife.Payload

  @primary_key false
  embedded_schema do
    embeds_one :agg_id, :string
    embeds_one :payload, Payload
    embeds_one :meta, MetaData
  end

  def as_hope(%MilkToAnalyse.CaptureLife.Cmd{} = cmd),
    do: Map.from_struct(cmd)

   





end
