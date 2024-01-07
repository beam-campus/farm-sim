defmodule Agrex.Region.SystemTest do
  use ExUnit.Case


  @test_landscape 

  @tag :ignore_test
  doctest Agrex.Region.System

  alias Agrex.Region.System

  @tag :ignore_test
  test "that the Agrex.Region.System module exists" do
    assert is_list(Agrex.Region.System.module_info())
  end


  # @tag :ignore_test
  test "that we can start a Agrex.Region.System" do
    landscape = @test_landscape
    res =  Agrex.Region.System.start_link(nil,nil)
    case res do
      {:ok, pid} ->
        assert pid != nil
        assert Process.alive?(pid)
      {:error, {:already_started, pid}} ->
        assert pid != nil
        assert Process.alive?(pid)
    end
  end


end
