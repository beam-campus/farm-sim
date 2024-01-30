defmodule Agrex.Born2Died.Rules do

  @moduledoc """
  Agrex.Born2Died.Rules is the module that contains the rules for the Life
  """
  @ticks_per_year 2
  @max_age 20

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

  def apply_age(state)
      when state.vitals.age > div(@max_age, 2) do
    state = put_in(state.vitals.health, state.vitals.health - 1)
    state
  end

  def apply_age(state)
      when state.vitals.age <= div(@max_age, 2) do
    state = put_in(state.vitals.health, state.vitals.health + 1)
    state
  end

  def apply_age(state),
    do: state
end
