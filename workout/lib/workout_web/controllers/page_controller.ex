defmodule WorkoutWeb.PageController do
  use WorkoutWeb, :controller
  import Plug.Conn
  alias Workout.Accounts
  alias Workout.Workouts
  alias Workout.Workouts.Serie
  alias Workout.Accounts.User
  alias WorkoutWeb.Utilis
  import Phoenix.HTML
  alias Contex
  alias WorkoutWeb.Router.Helpers, as: Routes

  def home(conn, _params) do
    render(conn, :register, layout: false)
  end

  def menu(conn, _params) do
    render(conn, :menu, layout: false)
  end

  def register_workout(conn, _params) do
    exercises = Workouts.get_list_of_name
    IO.inspect(exercises)
    conn
    |> assign(:exercises,exercises)
    |> render(:register_workout, layout: false)
  end

  def stats(conn, _params) do
    user_id = get_session(conn, :user_id)
    exercise_id = get_session(conn, :exercise_id) || 1
    conn
    |> assign(:exercise_id, exercise_id)
    |> assign(:user_id, user_id)
    |> render(:stats, layout: false)
  end

  def submit_stats(conn, %{"exercise" => exercise}) do
    exercise = Workouts.get_id!(exercise)
    IO.inspect(exercise.id)

    case exercise.id do
      nil ->
        conn
        |> put_flash(:error, "Invalid exercise name")
        |> redirect(to: "/stats")

      exercise_id ->
        conn
        |> put_session(:exercise_id, exercise_id)
        |> redirect(to: "/api/workout/stats")
    end
  end

  def submit_workout(conn,%{"workout"=> list} ) do
    result =
      Enum.reduce(list, %{}, fn %{"exercise" => exercise, "reps" => reps}, acc ->
        Map.update(acc, exercise, [reps], fn reps_list -> [reps | reps_list] end)
      end)
    IO.inspect(result)
    user_id = get_session(conn, :user_id)
    result
    |>Enum.map( fn {name,reps} ->
      exercise = Workouts.get_id!(name)
      attrs = %{
        user_id: user_id,
        exercise_id: exercise.id,
        reps: reps,
        date: NaiveDateTime.utc_now()
      }

    case Workouts.create_serie(attrs) do
      {:ok, _series} -> nil

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Failed to add workout", details: changeset.errors})
    end
  end)
  conn
  |> put_status(:created)
  |> json(%{message: "Workout added successfully!"})
  end
end
