defmodule Workout.UserSupervisor do
  use DynamicSupervisor
  alias Workout.GenWorkout

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_user_process(user_id, data) do
    child_spec = {GenWorkout, {data, String.to_atom("user_#{user_id}")}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def stop_user_process(user_id) do
    case Process.whereis(String.to_atom("user_#{user_id}")) do
      nil -> {:error, :not_found}
      pid -> DynamicSupervisor.terminate_child(__MODULE__, pid)
    end
  end
end
