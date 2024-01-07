defmodule Agrex.LandscapeSystemTest do
  use ExUnit.Case

  alias Agrex.Landscape.System
  alias Agrex.Schema.Landscape

  @farmtrace_ls %{
    name: "FarmTrace",
    nbr_of_farms: 3
  }

  @tag :ignore_test
  doctest Agrex.Landscape.System

  @tag :ignore_test
  test "that the module exists" do
    assert is_list(System.module_info())
  end

  @tag :ignore_test
  test "that we can init the Landscape.System" do
    ## GIVEN
    {:ok, ls} =
      Landscape.new(@farmtrace_ls)

    ## WHEN
    {:ok, res}=
      System.init(ls)

    ## THEN
    assert res != nil
  end

  @tag :ignore_test
  test "that we can start the Landscape.System for a given Landscape" do
    ## GIVEN
    {:ok, ls} =
      Landscape.new(@farmtrace_ls)

    IO.inspect(ls, [])
    ## WHEN
    pid =
      case System.start_link([name: "data", landscape: @farmtrace_ls]) do
        {:error, {:already_started, pid}} ->
          pid
        {:ok, pid} ->
          pid
      end
    ## THEN
    children = Supervisor.which_children(pid)
    assert children != nil
    IO.inspect(children, [])
  end
end
