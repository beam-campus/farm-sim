defmodule Agrex.Countries.Cache do
  use GenServer

  require Req
  require Logger
  import LogHelper

  @all_countries_url "https://restcountries.com/v3.1/all"

  ####### API ###############
  def refresh do
    GenServer.cast(
      __MODULE__,
      {:refresh}
    )
  end

  def clear() do
    GenServer.cast(
      __MODULE__,
      {:clear}
    )
  end

  def all_countries() do
    GenServer.call(
      __MODULE__,
      {:all_countries}
    )
  end

  def random_country() do
    GenServer.call(
      __MODULE__,
      {:random_country}
    )
  end

  def independent_countries(min_population) do
    GenServer.call(
      __MODULE__,
      {:independent_countries, min_population}
    )
  end

  def farmable_countries(min_area, min_population)
      when is_integer(min_area) and
             is_integer(min_population) do
    GenServer.call(
      __MODULE__,
      {
        :farmable_countries,
        min_area,
        min_population
      }
    )
  end

  def start_link(init_arg) do
    Logger.info("in:init_args = #{inspect(init_arg)}")
    state = Req.get!(@all_countries_url).body()
    res = GenServer.start_link(
      __MODULE__,
      state,
      name: __MODULE__
    )
    log_res(res)
    res
  end

  def start() do
    case res = start_link([]) do
      {:ok, _pid} ->
        res
      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  ######## IMPLEMENTATION ##########
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:refresh}, _state) do
    state = Req.get!(@all_countries_url).body()
    {:noreply, state}
  end

  @impl true
  def handle_cast({:clear}, _state) do
    {:noreply, []}
  end

  @impl true
  def handle_call({:independent_countries, min_population}, _from, state) do
    refresh()

    names =
      state
      |> Stream.filter(fn c -> c["independent"] end)
      |> Stream.filter(fn c -> c["population"] >= min_population end)
      |> Stream.map(fn c -> c["name"]["common"] end)
      |> Enum.sort()

    {:reply, names, state}
  end

  @impl GenServer
  def handle_call({:all_countries}, _from, state) do
    names =
      state
      |> Stream.map(fn c -> c["name"]["common"] end)
      |> Enum.sort()

    {:reply, names, state}
  end

  @impl GenServer
  def handle_call({:random_country}, _from, state) do
    name =
      state
      |> Stream.map(fn c -> c["name"]["common"] end)
      |> Enum.random()

    {:reply, name, state}
  end

  @impl GenServer
  def handle_call(
        {:farmable_countries, area, pop},
        _from,
        state
      ) do
    countries =
      state
      |> Stream.filter(&is_farmable?(&1, area, pop))
      |> Stream.map(fn c -> c["name"]["common"] end)
      |> Enum.sort()

    {:reply, countries, state}
  end


  ### PRIVATES ###
  defp is_farmable?(c, min_area, min_population) do
    c["area"] >= min_area and
      c["population"] >= min_population and
      abs(Enum.at(c["latlng"], 0)) >= 12 and
      abs(Enum.at(c["latlng"], 0)) <= 65 and
      c["independent"]
  end

end
