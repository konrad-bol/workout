defmodule Workout.GenWorkout do
  use GenServer

  def start_link({init, name}) do
    IO.inspect("zazcecei genserver z nazw: #{name}")
    GenServer.start_link(__MODULE__, init, name: name)
  end

  def add_series(pid, series) do
    GenServer.call(pid, {:add_series, series})
  end
  def add_series(pid, series,date) do
    GenServer.call(pid, {:add_series, series,date})
  end

  def get_series(pid, exercise) do
    GenServer.call(pid, {:get_series, exercise})
  end

  def get_workout(pid) do
    GenServer.call(pid, :get_workout)
  end

  def init(init_arg) do
    IO.inspect("zadzailal init")
    {:ok, init_arg}
  end

  def handle_call({:add_series, series}, _from, state) do
    updated_state =
      series
      |> Enum.reduce(state, fn {exercise, reps}, acc ->
        # acc =
        Map.update(acc, Date.utc_today(), %{exercise => reps}, fn current_val ->
          Map.update(current_val, exercise, reps, fn workout ->
            workout ++ reps
          end)
        end)
      end)

    {:reply, :added, updated_state}
  end
  def handle_call({:add_series, series,date}, _from, state) do
    updated_state =
      series
      |> Enum.reduce(state, fn {exercise, reps}, acc ->
        Map.update(acc, date, %{exercise => reps}, fn current_val ->
          Map.update(current_val, exercise, reps, fn workout ->
            workout ++ reps
          end)
        end)
      end)

    {:reply, :added, updated_state}
  end

  def handle_call({:get_series, exercise}, _from, state) do
    serie =
      state
      |> Enum.reduce(%{}, fn {date, workout}, acc ->
        case Map.get(workout, exercise) do
          nil -> acc
          reps -> Map.put(acc, date, reps)
        end
      end)

    {:reply, serie, state}
  end

  def handle_call(:get_workout, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:do_work, state) do
    IO.inspect("Doing work with state: #{inspect(state)}")
    # Długotrwała operacja
    {:noreply, state}
  end

  def terminate(reason, _state) do
    IO.inspect("GenServer terminating due to: #{inspect(reason)}")
  end
end
