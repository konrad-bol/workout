defmodule Workout.WorkoutsTest do
  use Workout.DataCase

  alias Workout.Workouts

  describe "exercise" do
    alias Workout.Workouts.Exercises

    import Workout.WorkoutsFixtures

    @invalid_attrs %{name: nil}

    test "list_exercise/0 returns all exercise" do
      exercises = exercises_fixture()
      assert Workouts.list_exercise() == [exercises]
    end

    test "get_exercises!/1 returns the exercises with given id" do
      exercises = exercises_fixture()
      assert Workouts.get_exercises!(exercises.id) == exercises
    end

    test "create_exercises/1 with valid data creates a exercises" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Exercises{} = exercises} = Workouts.create_exercises(valid_attrs)
      assert exercises.name == "some name"
    end

    test "create_exercises/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workouts.create_exercises(@invalid_attrs)
    end

    test "update_exercises/2 with valid data updates the exercises" do
      exercises = exercises_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Exercises{} = exercises} = Workouts.update_exercises(exercises, update_attrs)
      assert exercises.name == "some updated name"
    end

    test "update_exercises/2 with invalid data returns error changeset" do
      exercises = exercises_fixture()
      assert {:error, %Ecto.Changeset{}} = Workouts.update_exercises(exercises, @invalid_attrs)
      assert exercises == Workouts.get_exercises!(exercises.id)
    end

    test "delete_exercises/1 deletes the exercises" do
      exercises = exercises_fixture()
      assert {:ok, %Exercises{}} = Workouts.delete_exercises(exercises)
      assert_raise Ecto.NoResultsError, fn -> Workouts.get_exercises!(exercises.id) end
    end

    test "change_exercises/1 returns a exercises changeset" do
      exercises = exercises_fixture()
      assert %Ecto.Changeset{} = Workouts.change_exercises(exercises)
    end
  end

  describe "serie" do
    alias Workout.Workouts.Series

    import Workout.WorkoutsFixtures

    @invalid_attrs %{date: nil, reps: nil}

    test "list_serie/0 returns all serie" do
      series = series_fixture()
      assert Workouts.list_serie() == [series]
    end

    test "get_series!/1 returns the series with given id" do
      series = series_fixture()
      assert Workouts.get_series!(series.id) == series
    end

    test "create_series/1 with valid data creates a series" do
      valid_attrs = %{date: ~N[2024-11-20 15:41:00], reps: [1, 2]}

      assert {:ok, %Series{} = series} = Workouts.create_series(valid_attrs)
      assert series.date == ~N[2024-11-20 15:41:00]
      assert series.reps == [1, 2]
    end

    test "create_series/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workouts.create_series(@invalid_attrs)
    end

    test "update_series/2 with valid data updates the series" do
      series = series_fixture()
      update_attrs = %{date: ~N[2024-11-21 15:41:00], reps: [1]}

      assert {:ok, %Series{} = series} = Workouts.update_series(series, update_attrs)
      assert series.date == ~N[2024-11-21 15:41:00]
      assert series.reps == [1]
    end

    test "update_series/2 with invalid data returns error changeset" do
      series = series_fixture()
      assert {:error, %Ecto.Changeset{}} = Workouts.update_series(series, @invalid_attrs)
      assert series == Workouts.get_series!(series.id)
    end

    test "delete_series/1 deletes the series" do
      series = series_fixture()
      assert {:ok, %Series{}} = Workouts.delete_series(series)
      assert_raise Ecto.NoResultsError, fn -> Workouts.get_series!(series.id) end
    end

    test "change_series/1 returns a series changeset" do
      series = series_fixture()
      assert %Ecto.Changeset{} = Workouts.change_series(series)
    end
  end
end
