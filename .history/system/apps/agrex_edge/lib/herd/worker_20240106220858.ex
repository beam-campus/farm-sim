defmodule Agrex.Herd.Worker do
  use GenServer

  @moduledoc """
  Documentation for `Agrex.Herd.Worker`.
  """

  ## API ###
  def child_spec(herd) do
    %{
      id: to_name(herdd),
      start: {__MODULE__, :start_link, [herd_id]},
      restart: :permanent,
      type: :worker
    }
  end



  ### Callbacks ###

  ### Internals ###


end
