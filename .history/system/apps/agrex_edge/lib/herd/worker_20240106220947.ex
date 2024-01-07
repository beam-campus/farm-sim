defmodule Agrex.Herd.Worker do
  use GenServer

  @moduledoc """
  Documentation for `Agrex.Herd.Worker`.
  """

  ## API ###
  def child_spec(herd) do
    %{
      id: to_name(herd.id),
      start: {__MODULE__, :start_link, [herd.id]},
      restart: :permanent,
      type: :worker
    }
  end


  def start_link(herd) do
    GenServer.start_link(
      __MODULE__,
      herd,
      name: via(herd.id)
    )
  end



  ### Callbacks ###

  @impl GenServer
  def ini do
    
  end

  ### Internals ###


end
