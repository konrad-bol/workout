defmodule Workout.Repo do
  use Ecto.Repo,
    otp_app: :workout,
    adapter: Ecto.Adapters.Postgres
end
