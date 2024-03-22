defmodule Agrex.Born2Died.Rules do
  @moduledoc """
  Agrex.Born2Died.Rules is the module that contains the rules for the Life
  """
  @ticks_per_year 2
  @max_age 20

  ######### CALCULATORS ################
  def calc_pos(state) do
    calc_delta = fn ->
      if :rand.uniform(2) == 1 do
        :rand.uniform(3) - 1
      else
        -:rand.uniform(3) + 1
      end
    end

    state = put_in(state.pos.x, state.pos.x + calc_delta.())
    state = put_in(state.pos.y, state.pos.y + calc_delta.())
    state
  end

  def calc_age(state)
      when state.ticks == @ticks_per_year do
    state = put_in(state.vitals.age, state.vitals.age + 1)
    state = put_in(state.ticks, 0)
    state
  end

  def calc_age(state) do
    state = put_in(state.ticks, state.ticks + 1)
    state
  end

  ######### APPLICATORS ################
  def apply_age(state)
      when state.vitals.age >= div(@max_age, 2) do
    state = put_in(state.vitals.health, state.vitals.health - 1)
    state
  end

  def apply_age(state)
      when state.vitals.age < div(@max_age, 2) do
    state = put_in(state.vitals.health, state.vitals.health + 1)
    state
  end

  def apply_age(state),
    do: state

  ####### EVALUATORS ################
  def eval(%Agrex.Born2Died.State{} = state) do
    state
    |> do_eval_vitals()
  end

  defp do_eval_age(state) do
    case state.vitals.age do
      age when age >= @max_age ->
        state
        |> put_in(state.status, :died)

      _ ->
        state
    end

    state
  end

  defp do_eval_health(state) do
    case state.vitals.health do
      health when health <= 0 ->
        state
        |> put_in(state.status, :died)

      _ ->
        state
    end

    state
  end

  defp do_eval_vitals(state) do
    state
    |> do_eval_age()
    |> do_eval_health()
  end
end
