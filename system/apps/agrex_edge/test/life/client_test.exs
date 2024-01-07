defmodule Agrex.Life.ClientTest do
  use ExUnit.Case, async: true

  @moduledoc """
  Tests for Agrex.Life.Client
  """
  doctest Agrex.Life.Client

  @farm_id "farm-1"

  alias Agrex.Life.Client

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
