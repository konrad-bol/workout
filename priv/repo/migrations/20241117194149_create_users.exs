defmodule Workout.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
  end
end
