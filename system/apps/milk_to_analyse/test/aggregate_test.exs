defmodule MilkToAnalyse.AggregateTest do
  use ExUnit.Case

  alias MilkToAnalyse.Aggregate

  @tag :ignore_test
  doctest MilkToAnalyse.Aggregate

  test "that the MilkToAnalyse.Aggregate exists" do
    assert is_list(MilkToAnalyse.Aggregate.module_info())
  end



end
