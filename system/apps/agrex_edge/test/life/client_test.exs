defmodule Agrex.Life.ClientTest do
  use ExUnit.Case, async: true

  @moduledoc """
  Tests for Agrex.Life.Client
  """
  doctest Agrex.Life.Client

  @edge_id "edge-1"
  @default_vector %{x: 100, y: 100, z: 1}

  alias Agrex.Life.Client

  setup_all do
    state = Agrex.Life.State.random(@edge_id, @default_vector)
    res = Client.start_link(state)
    Logger.info("Agrex.Life.Client.start_link/1: #{inspect(res)}")
    res
  end

  @tag :life_client_test
  test "that the Client Module exists" do
    assert is_list(Client.module_info(:exports))
  end

  @tag :life_client_test
  test "that the Client Module has a child_spec/1 function" do
    assert Client.child_spec(@farm_id) == %{
      id: Client.via(@farm_id),
      start: {Agrex.Life.Client, :start_link, [@farm_id]},
      restart: :temporary,
      type: :worker
    }
  end





end
