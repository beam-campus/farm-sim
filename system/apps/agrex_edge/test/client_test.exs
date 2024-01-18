defmodule Agrex.Edge.ClientTest do
  use ExUnit.Case, async: true

  @moduledoc """
  Tests for Agrex.Edge.Client
  """
  require Logger
  doctest Agrex.Edge.Client

  @edge_id "edge-1"
  @default_vector %{x: 100, y: 100, z: 1}

  alias Agrex.Edge.Client

  setup_all do
    state = Agrex.Life.State.random(@edge_id, @default_vector)
    res = Client.start_link(state)
    Logger.info("Agrex.Edge.Client.start_link/1: #{inspect(res)}")
    :ok
  end

  @tag :life_client_test
  test "that the Client Module exists" do
    assert is_list(Client.module_info(:exports))
  end

  @tag :life_client_test
  test "that the Client Module has a child_spec/1 function" do
    assert Client.child_spec(@edge_id) == %{
      id: Client.to_name(@edge_id),
      start: {Agrex.Edge.Client, :start_link, [@edge_id]},
      restart: :transient,
      type: :worker
    }
  end








end
