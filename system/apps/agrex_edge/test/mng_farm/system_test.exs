defmodule Agrex.MngFarm.SystemTest do
  @moduledoc """
  This module tests the Agrex.Farm.System module.
  """
  use ExUnit.Case

  alias Agrex.MngFarm.System

  @tag :ignore_test
  doctest Agrex.MngFarm.System

  @tag :ignore_test
  test "that the Agrex.MngFarm.System module exists" do
    assert is_list(Agrex.MngFarm.System.module_info())
  end

end
