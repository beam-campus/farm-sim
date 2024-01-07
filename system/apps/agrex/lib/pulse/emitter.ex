defmodule Agrex.Pulse.Emitter do
  use GenServer

  require Logger

  alias Agrex.Pulse.{
    Config,
    Fact
  }

  def start_link(state) do
    GenServer.start_link(
      __MODULE__,
      state,
      name: __MODULE__
    )
  end

  def child_spec(%Config{} = config) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [config]},
      type: :worker
    }
  end

  @impl true
  def init(%Config{period_ms: delay_ms} = state) do
    Process.send_after(self(), :pulse, delay_ms)
    {:ok, state}
  end


  @impl true
  def handle_info(:pulse, %Config{period_ms: delay_ms, domain: domain} = state) do
    Phoenix.PubSub.broadcast!(
      Agrex.PubSub,
      Agrex.Topics.pulsed(domain),
      %Fact{
        timestamp: NaiveDateTime.utc_now()
      }
    )
    Process.send_after(self(), :pulse, delay_ms)
    {:noreply, state}
  end


end
