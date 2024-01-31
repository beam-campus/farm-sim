defmodule Agrex.Born2Died.AggregateTest do
  @moduledoc """
  Agrex.Born2Died.AggregateTest is the aggregate test for the Born2Died domain.
  """
  use ExUnit.Case, async: true

  test "that we can start the Aggregate Actor" do
    agg_state = %{
      state:
        Agrex.Born2Died.State.random(
          "edge_1",
          Agrex.Schema.Vector.new(100, 100, 0),
          Agrex.Schema.Life.random()
        ),
      events: []
    }

    case Agrex.Born2Died.Aggregate.start_link(agg_state) do
      {:ok, pid} ->
        assert {:ok, pid} == {:ok, pid}

      {error, {:already_started, pid}} ->
        assert {:ok, pid} == {:ok, pid}

      reply ->
        assert false
    end
  end
end
