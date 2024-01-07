defmodule MilkToAnalyse.Aggregate do
  use Ecto.Schema

  alias MilkToAnalyse.Aggregate
  alias MilkToAnalyse.Status
  alias MilkToAnalyse.State
  alias Flags

  alias MilkToAnalyse.CaptureLife.Cmd

  embedded_schema do
    field :agg_id, :string
    field :status, :integer
    embeds_one :state, State
  end

  # INTERFACE FUNCTIONS
  def initialize(
        %Aggregate{} = _aggregate,
        %MilkToAnalyse.Initialize.Cmd{agg_id: agg_id} = _cmd
      ) do
    %MilkToAnalyse.Initialize.Evt{agg_id: agg_id}
  end

  # STATE MUTATORS
  def apply(
        %Aggregate{status: status} = aggregate,
        %MilkToAnalyse.Initialize.Evt{agg_id: agg_id} = _event
      ) do
    aggregate
    |> Map.put(:agg_id, agg_id)
    |> Map.put(:status,  Flags.set(status, Status.initialized()))
  end
end
