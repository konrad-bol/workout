defmodule Workout.Repo.Migrations.ModifySeriesTable do
  use Ecto.Migration

  def change do
    alter table(:series) do
      # Dodaj nowe pole data
      add :data, :map, default: %{}
    end

    # Opcjonalnie usuń stare pola
    alter table(:series) do
      remove :reps
      remove :date
      remove :exercise_id
    end
  end
end
