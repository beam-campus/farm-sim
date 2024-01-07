defmodule Agrex.FarmWorker do
  use GenServer

  def start_link(farm) do
    GenServer.start_link(
      __MODULE__,
      [farm],
      name: {:global, farm.name}
    )
    do_loop()
  end

  defp do_loop() do
    do_loop()
  end


  def init(farm) do
    {:ok, farm}
  end
end
