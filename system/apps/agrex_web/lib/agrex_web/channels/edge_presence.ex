defmodule AgrexWeb.EdgePresence do
  use Phoenix.Presence,
  otp_app: :agrex_web,
  pubsub_server: Agrex.PubSub
  @moduledoc """
  The EdgePresence is used to broadcast messages to all clients
  """
  require Logger







end
