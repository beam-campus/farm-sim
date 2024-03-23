defmodule Agrex.Born2Died.EmitterTest do
  use ExUnit.Case

  @moduledoc """
  These are the tests for Agrex.Born2Died.Emitter
 """

  require Logger
  alias Agrex.Born2Died.Emitter

  @edge_id "edge-1"

  setup_all do
    res = AgrexEdge.Client.start_link(@edge_id)
    Logger.info("AgrexEdge.Client.start_link/1: #{inspect(res)}")
    res
  end

  @tag :ignore_test
  test "that the Agrex.Born2Died.Emitter module exists" do
    assert is_list(Agrex.Born2Died.Emitter.module_info())
  end

  test "emit_born/2 emits the 'emit_born' fact" do
    # Arrange
    life_id = 123
    fact = %{name: "John", age: 30}

    # Act
    result = Emitter.emit_born(life_id, {:emit_born, fact})

    # Assert
    assert result == {:ok, {:emit_born, fact}}
  end

  test "emit_died/2 emits the 'emit_died' fact" do
    # Arrange
    life_id = 123
    fact = %{name: "John", age: 30}

    # Act
    result = Emitter.emit_died(life_id, {:emit_died, fact})

    # Assert
    assert result == {:ok, {:emit_died, fact}}
  end

  test "via/1 returns the correct tuple" do
    # Arrange
    life_id = 123

    # Act
    result = Emitter.via(life_id)

    # Assert
    assert result == {:emitter, "life-123"}
  end

  test "child_spec/1 returns the correct map" do
    # Arrange
    state = %{life: %{id: 123}}

    # Act
    result = Emitter.child_spec(state)

    # Assert
    assert result == %{
             id: {:emitter, "life-123"},
             start: {Agrex.Born2Died.Emitter, :start_link, [state]},
             type: :worker,
             restart: :transient
           }
  end

  test "start_link/1 returns the correct result" do
    # Arrange
    state = %{life: %{id: 123}}

    # Act
    result = Emitter.start_link(state)

    # Assert
    assert result == {:ok, {:emitter, "life-123"}}
  end
end
