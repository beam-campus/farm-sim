defmodule MilkToAnalyse.Initialize.Handler do
  @behaviour Commanded.Commands.Handler

  alias MilkToAnalyse.Aggregate
  alias MilkToAnalyse.Status

  def handle(
        %Aggregate{status: status} = aggregate,
        %MilkToAnalyse.Initialize.Cmd{agg_id: agg_id} = cmd
      ) do
    case status |> Flags.has_not(Status.initialized()) do
      true ->
        Aggregate.initialize(aggregate, cmd)

      _ ->
        {:error, "Aggregate #{agg_id} is already initialized"}
    end
  end
end
