defmodule Workout.Repo.Migrations.CreateSeries do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :reps, {:array, :integer}
      add :date, :naive_datetime
      add :user_id, references(:users, on_delete: :delete_all)
      add :exercise_id, references(:exercises, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:series, [:user_id])
    create index(:series, [:exercise_id])
  end
end
