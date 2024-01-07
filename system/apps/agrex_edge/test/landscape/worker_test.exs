defmodule Agrex.Landscape.WorkerTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  require Logger
  alias Agrex.Landscape
  alias Agrex.Landscape.Worker
  alias Agrex.Schema.Landscape
  alias Agrex.Schema.Region

  @valid_landscape_params [
    name: "test_landscape",
    nbr_of_regions: 5,
    min_area: 30_000,
    min_population: 10_000_000
  ]

  @tag :ignore_test
  doctest Agrex.Landscape.Worker

  describe "\n[~~> SETUP  Agrex.Landscape.Worker Tests <~~]" do
    setup %{} do
      Agrex.Countries.Cache.start()
      Agrex.Landscape.System.start_link(@valid_landscape_params)
      IO.puts("Agrex.Landscape.System has these children: #{inspect Agrex.Landscape.System.which_children()}")
      :ok
    end

    @tag :ignore_test
    test "\n ==> that the module Agrex.Landscape.Worker exists" do
      assert is_list(Worker.module_info())
    end

    test "that we can start the Landscape.Worker" do
      case Worker.start_link(@valid_landscape_params) do
        {:ok, pid} ->
          assert Process.alive?(pid)

        {:error, {:already_started, pid}} ->
          assert Process.alive?(pid)
      end
    end

    # @tag :ignore_test
    test "that we can add a region to an existing Landscape" do
      res = Agrex.Landscape.System.start_region("Belgium")
      IO.puts("Server.add_region was called and this is the result ==>")
      IO.inspect(res)
      # assert Process.alive?(landscape)
    end
  end
end
