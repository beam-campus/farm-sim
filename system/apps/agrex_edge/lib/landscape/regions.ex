defmodule Agrex.Landscape.Regions do
  use DynamicSupervisor

  require Logger
  import LogHelper

  ###### INTERFACES #############
  def child_spec(landscape_params) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [landscape_params, []]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }

    log_spec(spec)
  end

  @doc """
  Returns the list of children supervised by this module
  """
  def which_children() do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def start_link(landscape_params, opts \\ []) do
    Logger.info("in:landscape: #{inspect(landscape_params)}, in:opts: #{inspect(opts)}")

    res =
      DynamicSupervisor.start_link(
        __MODULE__,
        landscape_params,
        name: __MODULE__
      )

    log_res(res)
  end

  def start_region_system(region_id) do
    Logger.debug("in:region_id=#{inspect(region_id)}")
    res_sys =
      DynamicSupervisor.start_child(
        __MODULE__,
        {Agrex.Region.System, region_id}
      )

    log_res(res_sys)
  end

  ######### IMPLEMENTATION ############
  # @impl DynamicSupervisor
  def init(landscape_params) do
    Logger.info("in:landscape_params: #{inspect(landscape_params)}")

    DynamicSupervisor.init(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  ########### PRIVATE #####################
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
