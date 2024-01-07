defmodule Agrex.Facts.MilkingStartedTest do
  use ExUnit.Case

  alias Agrex.Facts.MilkingStarted

  @tag :ignore_test
  doctest MilkingStarted


  @valid_input %{
    payload: %{
      robot: %{
        id: %{
          prefix: "robot",
          value: "1234"
        },
        name: "Roberta"
      },
      life: %{
        id: "life-1234",
        life_number: "1234",
        gender: :female,
        responder_id: "resp-52225"
      }
    }
  }

  @tag :ignore_test
  test "that the MilkingStarted module exists" do
    assert is_list(MilkingStarted.module_info())
  end

  @tag :ignore_test
  test "that the MilkingStarted.Payload module exists" do
    assert is_list(MilkingStarted.Payload.module_info())
  end

  @tag :ignore_test
  test "that we can create a new MilkingStarted fact from valid input, using new/1" do
    case MilkingStarted.new(@valid_input) do
      {:ok, fact} ->
        assert fact != nil
        assert fact.payload != nil
        IO.inspect(fact, [])
      _ ->
        assert false
    end
  end






end
