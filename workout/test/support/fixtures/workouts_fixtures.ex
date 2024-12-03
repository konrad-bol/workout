defmodule Workout.WorkoutsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Workout.Workouts` context.
  """

  @doc """
  Generate a unique exercises name.
  """
  def unique_exercises_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a exercises.
  """
  def exercises_fixture(attrs \\ %{}) do
    {:ok, exercises} =
      attrs
      |> Enum.into(%{
        name: unique_exercises_name()
      })
      |> Workout.Workouts.create_exercises()

    exercises
  end

  @doc """
  Generate a series.
  """
  def series_fixture(attrs \\ %{}) do
    {:ok, series} =
      attrs
      |> Enum.into(%{
        date: ~N[2024-11-20 15:41:00],
        reps: [1, 2]
      })
      |> Workout.Workouts.create_series()

    series
  end
end
