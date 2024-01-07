defmodule Agrex.Registry do


  require Logger

  ############ INTERFACE ###########
  def register(key, pid) do
    Registry.register(__MODULE__, key, pid)
  end

  def start_link do
      Registry.start_link(
        keys: :unique,
        name: __MODULE__
      )
  end

  def via_tuple(key) do
    {:via, Registry, {__MODULE__,  key}}
  end

  # def via_tuple(key) do
  #   {:via, Registry, key}
  # end


  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end

  def lookup(key) do
    Registry.lookup(__MODULE__, key)
  end

end
