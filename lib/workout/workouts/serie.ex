defmodule Workout.Workouts.Serie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "series" do
    field :data, :map


    belongs_to :user, Workout.Accounts.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(serie, attrs) do
    serie
    |> cast(attrs, [ :data,:user_id])
    |> validate_required([ :data,:user_id])
  end
end
