defmodule MilkToAnalyse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MilkToAnalyse.Worker.start_link(arg)
      # {MilkToAnalyse.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MilkToAnalyse.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
