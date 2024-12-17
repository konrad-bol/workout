defmodule WorkoutWeb.UserController do
  use WorkoutWeb, :controller
  import Plug.Conn
  alias Workout.Accounts
  alias Workout.Accounts.User
  alias WorkoutWeb.Utilis
  alias Workout.GenWorkout
  alias Workout.UserSupervisor

  plug(:dont_exploit_me when action in [:register, :login])
  plug(:ensure_authenticated when action in [:logout])

  def profil(conn, _params) do
    user_id = get_session(conn, :user_id)
    render(conn, "profil.json", %{user: Accounts.get_user!(user_id)})
  end

  def logout(conn, _params) do
    user_id = get_session(conn, :user_id)

    case UserSupervisor.stop_user_process(user_id) do
      :ok ->
        IO.inspect("dzialam normalnie")
        IO.inspect(get_session(conn, :user_id), label: "Before clearing session")
        conn = Plug.Conn.clear_session(conn)
        IO.inspect(get_session(conn, :user_id), label: "After clearing session")

        conn
        |> put_status(:ok)
        |> render("logout.json", %{message: "Successfully logged out"})

      {:error, :not_found} ->
        IO.inspect("nie dzialam error")

        conn
        |> Plug.Conn.clear_session()
        |> put_status(404)
        |> render("error.json", %{error: "User process not found"})
    end
  end

  def register(conn, input) do
    case Accounts.create_user(input) do
      {:ok, user} ->
        # get data from DB
        data_input = %{}

        case UserSupervisor.start_user_process(user.id, data_input) do
          {:ok, pid} ->
            GenWorkout.get_workout(String.to_atom("user_#{user.id}"))
            |> IO.inspect()

            conn
            |> put_status(:created)
            |> put_session(:user_id, user.id)
            |> put_session(:pid, pid)
            |> render("register.json", %{user: user})

          {:error, reason} ->
            conn
            |> put_status(500)
            |> render("error.json", %{error: "Failed to start user process: #{reason}"})
        end

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", %{error: Utilis.format_chageset_errors(changeset)})
    end
  end

  def login(conn, input) do
    IO.puts("loguje sie")
    IO.inspect(input)
    IO.inspect(conn)

    User.login_changeset(input)
    |> case do
      %Ecto.Changeset{valid?: true, changes: %{password: password, username: username}} ->
        IO.inspect(username)

        case user = Accounts.get_by_username(username) do
          %User{} ->
            if Argon2.verify_pass(password, user.password) do
              # get data from DB
              data_input = Workout.Workouts.get_user_series_data(user.id)
              IO.inspect(data_input)
              # {:ok, pid} = GenWorkout.start_link(data_input, String.to_atom("user_#{user.id}"))

              case UserSupervisor.start_user_process(user.id, data_input) do
                {:ok, pid} ->
                  GenWorkout.get_workout(String.to_atom("user_#{user.id}"))
                  |> IO.inspect()

                  conn
                  |> put_status(:created)
                  |> put_session(:user_id, user.id)
                  |> put_session(:pid, pid)
                  |> render("login.json", %{user: user})

                {:error, reason} ->
                  conn
                  |> put_status(500)
                  |> render("error.json", %{error: "Failed to start user process: #{reason}"})
              end
            else
              conn
              |> put_status(401)
              |> render("error.json", %{error: "wrong password"})
            end

          _ ->
            conn
            |> put_status(404)
            |> render("error.json", %{error: "404"})
        end

      _ ->
        conn
        |> put_status(404)
        |> render("error.json", %{error: "errors 404 "})
    end
  end

  defp dont_exploit_me(conn, _opts) do
    IO.inspect(conn.assigns, label: "to jest conn w dont exploit")
    case conn.assigns.user_signed_in? do
      true ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", %{error: "You can't be logged in"})
        |> halt()

      _user ->
        conn
    end
  end

  defp ensure_authenticated(conn, _opts) do
    case conn.assigns.user_signed_in? do
      false ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", %{error: "You must be logged in"})
        |> halt()

      _user ->
        conn
    end
  end
end
