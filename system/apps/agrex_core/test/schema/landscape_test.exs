defmodule Agrex.Schema.LandscapeTest do
  use ExUnit.Case

  alias Agrex.Schema.Landscape


  @valid_landscape_map %{
    name: "my-landscape",
    regions: [
      %{
        name: "us-west-1",
        description: "United States, West Coast 1"
      }
    ]
  }

  @tag :ignore_test
  test "that the module Agrex.Schema.Landscape exists" do
    assert is_list(Agrex.Schema.Landscape.module_info())
  end

  @tag :ignore_test
  test "that we can create a Landscape from a valid input using new/1 " do
    case Landscape.new(@valid_landscape_map) do
      {:ok, landscape} ->
        assert landscape != nil
        assert landscape.name == "my-landscape"
        IO.inspect(landscape, [])

      _ ->
        assert false
    end
  end

end
