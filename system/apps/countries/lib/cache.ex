defmodule Agrex.Countries.Cache do
  @moduledoc """
  Agrex.Countries.Cache is a GenServer that manages a cache of countries,
  obtained from a REST API at https://restcountries.com/v3.1/all,
  and provides a set of functions to query this cache.
  """
  use GenServer

  require Req
  require Logger

  @all_countries_url "https://restcountries.com/v3.1/all"

  ####### API ###############
  def refresh,
    do: GenServer.cast(__MODULE__, {:refresh})

  def clear(),
    do: GenServer.cast(__MODULE__, {:clear})

  def all_countries(),
    do: GenServer.call(__MODULE__, {:all_countries})

  def random_country(),
    do: GenServer.call(__MODULE__, {:random_country})

  def independent_countries(min_population)
      when is_integer(min_population),
      do: GenServer.call(__MODULE__, {:independent_countries, min_population})

  def farmable_countries(min_area, min_population)
      when is_integer(min_area) and
             is_integer(min_population),
      do: GenServer.call(__MODULE__, {:farmable_countries, min_area, min_population})

  def all_regions(),
    do: GenServer.call(__MODULE__, {:all_regions})

  def countries_of_regions(list_of_regions, min_area, min_population),
    do:
      GenServer.call(
        __MODULE__,
        {:countries_of_regions, list_of_regions, min_area, min_population}
      )

  ######## CALLBACKS ##########
  @impl true
  def init(_url) do
    state = Req.get!(@all_countries_url).body()
    {:ok, state}
  end

  @impl true
  def handle_cast({:refresh}, _state) do
    Logger.info("Refreshing countries cache")
    state = Req.get!(@all_countries_url).body()
    {:noreply, state}
  end

  @impl true
  def handle_cast({:clear}, _state) do
    {:noreply, []}
  end

  @impl true
  def handle_call(
        {:countries_of_regions, list_of_regions, min_area, min_population},
        _from,
        state
      ) do
    regions_with_subregions_and_countries =
      state
      |> Stream.filter(fn c ->
        c["independent"] &&
          c["area"] >= min_area &&
          c["population"] >= min_population &&
          c["region"] in list_of_regions
      end)
      |> Stream.map(
        &%{region: &1["region"], name: &1["name"]["common"], subregion: &1["subregion"]}
      )
      |> Enum.sort()

    {:reply, regions_with_subregions_and_countries, state}
  end

  @impl true
  def handle_call({:all_regions}, _from, state) do
    regions =
      state
      |> Stream.map(fn c -> c["region"] end)
      |> Stream.uniq()
      |> Enum.sort()

    {:reply, regions, state}
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
  def handle_call({:farmable_countries, area, pop}, _from, state),
    do: {
      :reply,
      state
      |> Stream.filter(&farmable?(&1, area, pop))
      |> Stream.map(fn c -> c["name"]["common"] end)
      |> Enum.sort(),
      state
    }

  ########### INTERNALS ##########
  defp farmable?(country, min_area, min_population) do
    country["area"] >= min_area and
      country["population"] >= min_population and
      abs(Enum.at(country["latlng"], 0)) >= 12 and
      abs(Enum.at(country["latlng"], 0)) <= 65 and
      country["independent"]
  end

  ######### PLUMBING ##########
  def start_link(state),
  do:
    GenServer.start_link(__MODULE__, state, name: __MODULE__)


  def start() do
    case res = start_link([]) do
      {:ok, _pid} ->
        res

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def child_spec(),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :transient
    }
end
