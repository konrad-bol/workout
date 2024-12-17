defmodule WorkoutWeb.PageController do
  use WorkoutWeb, :controller
  import Plug.Conn
  # alias Workout.Accounts
  alias Workout.Workouts
  # alias Workout.Workouts.Serie
  # alias Workout.Accounts.User
   alias WorkoutWeb.Utilis
  # import Phoenix.HTML
  alias Contex
  # alias WorkoutWeb.Router.Helpers, as: Routes
  alias Workout.GenWorkout

  def home(conn, _params) do
    render(conn, :register, layout: false)
  end

  def menu(conn, _params) do
    render(conn, :menu, layout: false)
  end

  def register_workout(conn, _params) do
    exercises = Workouts.get_list_of_name()
    IO.inspect(exercises)

    conn
    |> assign(:exercises, exercises)
    |> render(:register_workout, layout: false)
  end

  def stats(conn, _params) do
    user_id = get_session(conn, :user_id)
    exercise = get_session(conn, :exercise) || "push_up"

    conn
    |> assign(:exercise, exercise)
    |> assign(:user_id, user_id)
    |> render(:stats, layout: false)
  end

  def submit_stats(conn, %{"exercise" => name_exercise}) do
    exercise = Workouts.get_id!(name_exercise)
    IO.inspect(exercise.id)

    case exercise.id do
      nil ->
        conn
        |> put_flash(:error, "Invalid exercise name")
        |> redirect(to: "/stats")

      _exercise_id ->
        conn
        |> put_session(:exercise, name_exercise)
        |> redirect(to: "/api/workout/stats")
    end
  end

  def submit_workout(conn, %{"workout" => list}) do
    IO.inspect(list)

    result =
      Enum.reduce(list, %{}, fn %{"exercise" => exercise, "reps" => reps}, acc ->
        Map.update(acc, exercise, [reps], fn reps_list -> [reps | reps_list] end)
      end)

    IO.inspect(result)
    user_id = get_session(conn, :user_id)
    pid = get_session(conn, :pid)
    IO.inspect(pid)

    case GenWorkout.add_series(pid, result) do
      :added ->
        GenWorkout.get_workout(pid)
        |> Workouts.update_series(user_id)
        |> case do
          {:ok, _series} ->
            conn
            |> put_status(:created)
            |> json(%{message: "Workout added successfully!"})

          {:error, changeset} ->
            conn
            |> put_status(401)
            |> render("error.json", %{error: Utilis.format_chageset_errors(changeset)})
        end
        _->
          conn
          |> put_status(401)
          |> render("error.json", %{error: "error when submit workout"})
    end
  end
end
