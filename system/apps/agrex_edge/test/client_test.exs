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
    state =
      Agrex.Born2Died.State.random(
        @edge_id,
        @default_vector,
        Agrex.Schema.Life.random()
      )

    res = Client.start_link(state)
    Logger.info("Agrex.Edge.Client.start_link/1: #{inspect(res)}")
    :ok
  end

  @tag :life_client_test
  test "that the Client Module exists" do
    assert is_list(Client.module_info(:exports))
  end


  @tag :life_client_test
  test "that the Client Module has a to_name/1 function" do
    assert Client.to_name(@edge_id) == "edge.client:#{@edge_id}"
  end

  @tag :life_client_test
  test "that the Client Module has a to_topic/1 function" do
    assert Client.to_topic(@edge_id) == "edge:lobby:#{@edge_id}"
  end

  @tag :life_client_test
  test "that the Client Module has a via/1 function" do
    assert Client.via(@edge_id) == {
             :via,
             Registry,
             {Agrex.Registry, {:client, "edge.client:#{@edge_id}"}}
           }
  end


  @tag :life_client_test
  test "that the Client Module has a start_link/1 function" do
    case Client.start_link(@edge_id) do
      {:ok, pid} ->
        assert is_pid(pid)

      {:error, reason} ->
        assert false
    end
  end


end
