defmodule MilkToAnalyse.SanitizeLife.Evt do
  alias Schema.MetaData
  alias MilkToAnalyse.SanitizeLife.Payload
  use Ecto.Schema

  embedded_schema do
    field :agg_id, :string
    embeds_one :payload, Payload
    embeds_one :meta, MetaData
  end

end
