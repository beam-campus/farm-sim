defmodule Agrex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  use Application

  @moduledoc false
  @impl Application
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Agrex.Repo,
      # Start Finch
      {Finch, name: Agrex.Finch},
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: __MODULE__
    )
  end

  def stop() do
    Supervisor.stop(__MODULE__)
  end
end
