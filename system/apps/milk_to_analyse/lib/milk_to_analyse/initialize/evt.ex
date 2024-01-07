defmodule MilkToAnalyse.Initialize.Evt do
  alias Schema.MetaData
  alias MilkToAnalyse.Initialize.Payload
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :agg_id, :string
    embeds_one :payload, Payload
    embeds_one :meta, MetaData
  end

end
