defmodule Agrex.Landscape.System do
  require Logger
  import LogHelper

  ###### INTERFACE #############
  def via(landscape_name),
    do: Agrex.Registry.via_tuple(to_name(landscape_name))

  def to_name(name),
    do: "landscape.system.#{name}"

  def child_spec(landscape_params) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [landscape_params]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }

    log_spec(spec)
  end

  @doc """
  Returns the list of children supervised by this module
  """
  def which_children(landscape_name) do
    Supervisor.which_children(via(landscape_name))
  end

  def start_link(landscape_params) do
    Logger.info("\n\n\tin:landscape: #{inspect(landscape_params)}\n\n")

    children = [
      {Agrex.Landscape.Regions, landscape_params},
      {Agrex.Landscape.Worker, landscape_params}
    ]

    Supervisor.start_link(
      children,
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

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

  ######### CALLBACKS ############
  # def init(landscape_params) do
  #   Logger.info("\n\n\tin:landscape_params: #{inspect(landscape_params)}\n")
  #   Supervisor.init(
  #     __MODULE__,
  #     strategy: :one_for_one
  #   )

  # end

  # ########### PRIVATE #####################
  # defp do_start_landscape_worker(landscape_params) do
  #   Logger.debug("in:landscape_params=#{inspect(landscape_params)}")

  #   res =
  #     DynamicSupervisor.start_child(
  #       __MODULE__,
  #       {
  #         Agrex.Landscape.Worker,
  #         landscape_params
  #       }
  #     )
  #   log_res(res)
  # end
end
