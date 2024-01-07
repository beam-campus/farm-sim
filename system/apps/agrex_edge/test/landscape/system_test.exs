defmodule Agrex.Landscape.SystemTest do
  use ExUnit.Case

  require Logger

  @test_landscape_params [
    name: "farm_scape",
    nbr_of_regions: 5,
    min_area: 30_000,
    min_people: 10_000_000
  ]

  @tag :ignore_test
  doctest Agrex.Landscape.System

  describe "\n[~> Setup the Landscape.System test environment <~]" do
    setup %{} do
      case res = Agrex.Countries.Cache.start_link([]) do
        {:ok, cache} ->
          {:ok, cache}

        {:error, {:already_started, _}} ->
          Logger.info("Cache has already started")
      end
    end

    test "\n[== Test that we can start the Agrex.Landscape.System ==]" do
      res = Agrex.Landscape.System.start_link(@test_landscape_params)

      case res do
        {:ok, _} ->
          assert true

        {:error, {:already_started, _}} ->
          assert true
      end

      Logger.debug("Agrex.Landscape.System.start_link/1 returned => #{inspect(res)}")
    end

    @tag :ignore_test
    test "that the Agrex.Landscape.System module exists" do
      assert is_list(Agrex.Landscape.System.module_info())
    end

    @tag :ignore_test
    test "that we can start the Landscape.System for a particular landscape" do
      res =
        Agrex.Landscape.System.start_link(
          [name: "my_landscape", nbr_of_regions: 5],
          []
        )

      IO.inspect(res)
    end
  end
end
