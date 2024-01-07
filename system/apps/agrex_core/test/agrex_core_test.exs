defmodule Agrex.CoreTest do
  use ExUnit.Case
  doctest Agrex.Core

  test "greets the world" do
    assert Agrex.Core.hello() == :world
  end
end
