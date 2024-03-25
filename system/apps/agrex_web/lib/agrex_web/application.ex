defmodule AgrexWeb.Application do
  use Application, otp_app: :agrex_web
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc"""
  The main application module for AgrexWeb.
  """



  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AgrexWeb.Telemetry,

      # Start the Endpoint (http/https)
      AgrexWeb.EdgePresence,
      AgrexWeb.Endpoint,
      
      {AgrexWeb.ChannelWatcher, "edge:lobby"}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AgrexWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AgrexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
