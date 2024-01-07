defmodule MilkToAnalyse.NippleStatsTest do
  use ExUnit.Case

  alias MilkToAnalyse.Schema.NippleStats

  @tag :ignore_test
  doctest MilkToAnalyse.Schema.NippleStats

  @tag :ignore_test
  test "that module MilkToAnalyze.Schema.NippleStats exists" do
    assert is_list(MilkToAnalyse.Schema.NippleStats.module_info())
  end

  @valid_input %{
    milk_time: 15,
    dead_milk_time: 3,
    conductivity: 2,
    color_code: "ABC",
    scc: 5
  }

  @tag :ignore_test
  test "that we can get a valid changeset from a @valid_input" do
    case NippleStats.changeset(%NippleStats{}, @valid_input) do
      %{valid?: true} = changeset ->
        IO.puts("changeset resulted in \n")
        IO.inspect(changeset)
        assert true

      changeset ->
        IO.puts("changeset resulted in \n")
        IO.inspect(changeset)

        assert false
    end
  end
end
