defmodule Agrex.Herd.Worker do
  use GenServer

  @moduledoc """
  Documentation for `Agrex.Herd.Worker`.
  """

  ## API ###
  def child_spec(herd_id) do
    %{
      id: to_name(herd_id),
      start: {__MODULE__, :start_link, [herd_id]},
      restart: :permanent,
      type: :worker
    }
  end



  ### Callbacks ###

  ### Internals ###


end
