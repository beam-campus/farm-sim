defmodule AgrexWeb.Edge.ChannelTest do
  use AgrexWeb.ChannelCase

  @moduledoc """
  Tests for AgrexWeb.Edge.Channel
  """

  alias AgrexWeb.Edge.Channel

  setup do
    {:ok, _, socket} =
      AgrexWeb.EdgeSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(AgrexWeb.EdgeChannel, "edge:lobby")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to farm:lobby", %{socket: socket} do
    push(socket, "shout", %{"hello" => "all"})
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
