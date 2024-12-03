defmodule Workout.Workouts do
  @moduledoc """
  The Workouts context.
  """

  import Ecto.Query, warn: false
  alias Workout.Repo

  alias Workout.Workouts.Exercise

  @doc """
  Returns the list of exercise.

  ## Examples

      iex> list_exercise()
      [%Exercises{}, ...]

  """
  def list_exercise do
    Repo.all(Exercise)
  end
  def get_list_of_name do
    Repo.all(from(e in Exercise,select: e.name) )
  end
  def get_id!(exercise), do: Repo.get_by!(Exercise,name: exercise)

  @doc """
  Gets a single exercises.

  Raises `Ecto.NoResultsError` if the Exercises does not exist.

  ## Examples

      iex> get_exercises!(123)
      %Exercises{}

      iex> get_exercises!(456)
      ** (Ecto.NoResultsError)

  """
  def get_exercise!(id), do: Repo.get!(Exercise, id)


  @doc """
  Creates a exercises.

  ## Examples

      iex> create_exercises(%{field: value})
      {:ok, %Exercises{}}

      iex> create_exercises(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exercise(attrs \\ %{}) do
    %Exercise{}
    |> Exercise.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a exercises.

  ## Examples

      iex> update_exercises(exercises, %{field: new_value})
      {:ok, %Exercises{}}

      iex> update_exercises(exercises, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exercise(%Exercise{} = exercise, attrs) do
    exercise
    |> Exercise.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a exercises.

  ## Examples

      iex> delete_exercises(exercises)
      {:ok, %Exercises{}}

      iex> delete_exercises(exercises)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exercise(%Exercise{} = exercise) do
    Repo.delete(exercise)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exercises changes.

  ## Examples

      iex> change_exercises(exercises)
      %Ecto.Changeset{data: %Exercises{}}

  """
  def change_exercise(%Exercise{} = exercise, attrs \\ %{}) do
    Exercise.changeset(exercise, attrs)
  end

  alias Workout.Workouts.Serie

  @doc """
  Returns the list of serie.

  ## Examples

      iex> list_serie()
      [%Series{}, ...]

  """
  def list_series do
    Repo.all(Serie)
  end
  def get_list_user_series(user_id,exercise_id) do
    Repo.all(from( s in Serie, where: s.user_id==^user_id and s.exercise_id==^exercise_id,select: %{reps: s.reps, date: s.date}))
    |>Enum.map(fn %{date: date,reps: reps} ->%{x: NaiveDateTime.to_iso8601(date),y: Enum.sum(reps)}  end)
    |> Jason.encode!()
  end

  @doc """
  Gets a single series.

  Raises `Ecto.NoResultsError` if the Series does not exist.

  ## Examples

      iex> get_series!(123)
      %Series{}

      iex> get_series!(456)
      ** (Ecto.NoResultsError)

  """
  def get_serie!(id), do: Repo.get!(Serie, id)

  @doc """
  Creates a series.

  ## Examples

      iex> create_series(%{field: value})
      {:ok, %Series{}}

      iex> create_series(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_serie(attrs \\ %{}) do
    %Serie{}
    |> Serie.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a series.

  ## Examples

      iex> update_series(series, %{field: new_value})
      {:ok, %Series{}}

      iex> update_series(series, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_series(%Serie{} = serie, attrs) do
    serie
    |> Serie.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a series.

  ## Examples

      iex> delete_series(series)
      {:ok, %Series{}}

      iex> delete_series(series)
      {:error, %Ecto.Changeset{}}

  """
  def delete_serie(%Serie{} = serie) do
    Repo.delete(serie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking series changes.

  ## Examples

      iex> change_series(series)
      %Ecto.Changeset{data: %Series{}}

  """
  def change_serie(%Serie{} = serie, attrs \\ %{}) do
    Serie.changeset(serie, attrs)
  end
end
