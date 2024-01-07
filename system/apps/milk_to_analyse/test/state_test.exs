defmodule MilkToAnalyse.StateTest do
  use ExUnit.Case

  alias MilkToAnalyse.Status
  alias MilkToAnalyse.State

  @valid_input %{
    id: %{
      prefix: "attach-to-detach",
      value: "12345"
    },
    status: Status.unknown()
  }

  @tag :ignore_test
  doctest MilkToAnalyse.State

  @tag :ignore_test
  test "that the MilkToAnalyse.State module exists" do
    assert is_list(MilkToAnalyse.State.module_info())
  end

  @tag :ignore_test
  test "that changeset/2 produces a valid changeset for @valid_input" do
    state = %State{}

    case State.changset(state, @valid_input) do
      %{valid?: true} = changeset ->
        IO.puts("State.changeset/2 returned \n")
        IO.inspect(changeset)
        assert true

      changeset ->
        IO.puts("State.changeset/2 returned \n")
        IO.inspect(changeset)
        assert false
    end
  end

  test "that we can create a State using new/0" do
    state = State.new()
    IO.puts("State.new/1 created this state: \n")
    IO.inspect(state)
    assert state != nil
  end

end
