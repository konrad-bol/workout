defmodule Workout.Workouts.Serie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "series" do
    field :date, :naive_datetime
    field :reps, {:array, :integer}


    belongs_to :user, Workout.Accounts.User
    belongs_to :exercise, Workout.Workouts.Exercise
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(serie, attrs) do
    serie
    |> cast(attrs, [:reps, :date,:user_id,:exercise_id])
    |> validate_required([:reps, :date])
  end
end
