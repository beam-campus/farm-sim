defmodule Agrex.Schema.Meta do
  use Ecto.Schema

  @moduledoc """
  Agrex.Schema.Meta is the module that contains the facts for the Life Subsystem
  """
  alias Agrex.Schema.Id

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:topic, :string)
    field(:agg_id, :string)
    field(:correlation_id, :string)
    field(:causation_id, :string)
    field(:causation_type, :integer)
    field(:order, :integer)
    field(:timestamp, :utc_datetime)
  end



  @spec new(
          topic :: String.t(),
          agg_id :: String.t(),
          order :: Integer.t(),
          correlation_id :: String.t(),
          causation_id :: String.t(),
          causation_type :: Integer.t()
        ) :: %__MODULE__{}
  def new(
        topic,
        agg_id,
        order,
        correlation_id,
        causation_id,
        causation_type
      ),
      do: %__MODULE__{
        id:
          Id.new(topic)
          |> Id.to_string(),
        topic: topic,
        agg_id: agg_id,
        correlation_id: correlation_id,
        causation_id: causation_id,
        causation_type: causation_type,
        order: order,
        timestamp: DateTime.utc_now()
      }
end
