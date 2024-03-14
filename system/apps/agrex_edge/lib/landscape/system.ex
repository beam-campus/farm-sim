defmodule Agrex.Landscape.System do
  @moduledoc """
  Agrex.Landscape.System is the top-level supervisor for the Agrex.MngLandscape subsystem.
  """
  use GenServer

  import Logger

  ################# INTERFACE #############
  def start_europe do
    case start_link(Agrex.Landscape.InitParams.europe()) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def start_asia do
    case start_link(Agrex.Landscape.InitParams.asia()) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def start_region_system(landscape_id, region_init) do
    Logger.debug("for [#{landscape_id}] with region_init #{inspect(region_init)}")

    GenServer.cast(
      via(landscape_id),
      {:start_region_system, region_init}
    )
  end

  @doc """
  Returns the list of children supervised by this module
  """
  def which_children(landscape_id) do
    try do
      Supervisor.which_children(via_sup(landscape_id))
      |> Enum.reverse()
    rescue
      _ -> []
    end
  end

  ######## CALLBACKS ############
  @impl GenServer
  def handle_info({:EXIT, from_pid, reason}, state) do
    Logger.error(
      "#{Colors.red_on_black()}EXIT received from #{inspect(from_pid)} reason: #{inspect(reason)}#{Colors.reset()}"
    )

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:start_region_system, region_init}, %{id: landscape_id} = landscape_init) do
    debug("in:region_init=#{inspect(region_init)}")

    Supervisor.start_child(
      via_sup(landscape_id),
      {Agrex.Region.System, region_init}
    )

    {:noreply, landscape_init}
  end

  @impl GenServer
  def init(%{id: landscape_id} = landscape_init) do
    Process.flag(:trap_exit, true)

    children = [
      {Agrex.Landscape.Regions, landscape_init},
      {Agrex.Landscape.Builder, landscape_init}
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: via_sup(landscape_id)
    )

    Agrex.Landscape.Builder.init_landscape(landscape_init)

    {:ok, landscape_init}
  end

  ################# PLUMBIMG #####################
  def via(key),
    do: Agrex.Registry.via_tuple({:landscape_system, to_name(key)})

  def via_sup(key),
    do: Agrex.Registry.via_tuple({:landscape_sup, to_name(key)})

  def to_name(key) when is_bitstring(key),
    do: "landscape.system.#{key}"

  def child_spec(%{id: landscape_id} = landscape_init),
    do: %{
      id: via(landscape_id),
      start: {__MODULE__, :start_link, [landscape_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }

  def start_link(%{id: landscape_id} = landscape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        landscape_init,
        name: via(landscape_id)
      )

  # def start_region_system(region_id) do
  #   Logger.debug("in:region_id=#{inspect(region_id)}")

  #   res_sys =
  #     DynamicSupervisor.start_child(
  #       __MODULE__,
  #       {Agrex.Region.System, region_id}
  #     )

  #   log_res(res_sys)

  #   res_worker =
  #     case res_sys do
  #       {:ok, _pid} ->
  #         DynamicSupervisor.start_child(
  #           __MODULE__,
  #           {Agrex.Region.Worker, region_id}
  #         )

  #       {:error, {:already_started, _pid}} ->
  #         DynamicSupervisor.start_child(
  #           __MODULE__,
  #           {Agrex.Region.Worker, region_id}
  #         )
  #     end

  #   log_res(res_worker)
  #   res_worker
  # end

  # ########### PRIVATE #####################
  # defp do_start_landscape_worker(landscape_init) do
  #   Logger.debug("in:landscape_init=#{inspect(landscape_init)}")

  #   res =
  #     DynamicSupervisor.start_child(
  #       __MODULE__,
  #       {
  #         Agrex.Landscape.Worker,
  #         landscape_init
  #       }
  #     )
  #   log_res(res)
  # end
end
