defmodule Agrex.EdgeTest do
  use ExUnit.Case
  doctest Agrex.Edge

  test "test that module exists" do
    assert Agrex.Edge
  end
  test "greets the world" do
    assert Agrex.Edge.hello() == :world
  end
end
