defmodule MilkToAnalyse.Supervisor do
  use Supervisor

  @self __MODULE__

  def start_link(arg) do
    Supervisor.start_link(@self, arg, name: @self)
  end


  @impl true
  def init(_arg) do
    children = [
      MilkToAnalyse.App
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end


end
