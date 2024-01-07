defmodule Agrex.Life.Rules do
  @ticks_per_year 2
  @max_age 20

  def calc_age(state) do
    state = put_in(state.ticks, state.ticks + 1)

    new_state =
      case state.ticks do
        @ticks_per_year ->
          state = put_in(state.vitals.age, state.vitals.age + 1)
          state = put_in(state.ticks, 0)
          state

        _ ->
          state
      end

    new_state
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
end
