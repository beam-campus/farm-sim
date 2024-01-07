defmodule MilkToAnalyse.Schema.MetaData do
  use Ecto.Schema


  @primary_key false
  embedded_schema do
    field :landscape_id, :string
    field :region_id, :string
    field :farm_id, :string
    field :user_id, :string
    field :correlation_id, :string
    field :causation_id, :string
    field :timestamp, :utc_datetime
    field :order, :integer
  end

end
