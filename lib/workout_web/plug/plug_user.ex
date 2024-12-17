defmodule WorkoutWeb.Plug.PlugUser do
  alias Workout.Accounts
  alias Workout.Accounts.User
  import Plug.Conn
  def init(_params) do
  end

  def call(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :user_id)
      if user_id do
        Accounts.get_user!(user_id)
        |> case do
          %User{} ->
            conn
            |> assign(:user_signed_in?, true)
            |> assign(:current_user, Accounts.get_user!(user_id))

          _ ->
            conn
            |> assign(:user_signed_in?, false)
            |> assign(:current_user, nil)
        end
      else
        conn
        |> assign(:user_signed_in?, false)
        |> assign(:current_user, nil)
      end
  end
end
