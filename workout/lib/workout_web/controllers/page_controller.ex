defmodule WorkoutWeb.PageController do
  use WorkoutWeb, :controller
  import Plug.Conn
  alias Workout.Accounts
  alias Workout.Accounts.User
  alias WorkoutWeb.Utilis

  plug(:dont_exploit_me when action in [:register, :login])
  plug(:ensure_authenticated when action in [:logout])

  def home(conn, _params) do
    render(conn, :register, layout: false)
  end

  def logout(conn, _params) do
    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render("logout.json", %{message: "Successfully logged out"})
  end

  def register(conn, input) do
    case Accounts.create_user(input) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_session(:user_id, user.id)
        |> render("register.json", %{user: user})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", %{error: Utilis.format_chageset_errors(changeset)})
    end
  end

  def login(conn, input) do
    IO.puts("loguje sie")
    IO.inspect(input)

    User.login_changeset(input)
    |> case do
      %Ecto.Changeset{valid?: true, changes: %{password: password, username: username}} ->
        IO.inspect(username)

        case user = Accounts.get_by_username(username) do
          %User{} ->
            if Argon2.verify_pass(password, user.password) do
              conn
              |> put_status(:created)
              |> put_session(:user_id, user.id)
              |> render("login.json", %{user: user})
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
