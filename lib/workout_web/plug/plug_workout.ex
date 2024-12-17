defmodule WorkoutWeb.Plug.PlugWorkout do
  alias Workout.Accounts
  alias Workout.Accounts.User
  import Plug.Conn
  alias WorkoutWeb.Constants

  def init(_params) do
  end

  def call(conn, _params) do
    # czy potrzebne???
    # czy mozna zamiast nowego pluga kozystac z uzytkownika
    user_id = Plug.Conn.get_session(conn, :user_id)
    IO.inspect(user_id)
    if user_id do
      Accounts.get_user!(user_id)
      |> case do
        %User{} ->
          conn

        _ ->
          send_resp(conn, 401, Constants.not_authenticated())

          conn
          |> halt
      end
    else
      send_resp(conn, 401, Constants.not_authenticated())

      conn
      |> halt
    end
  end
end
