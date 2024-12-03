defmodule Workout.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Workout.Accounts.User

  schema "users" do
    field :username, :string
    field :password, :string

    has_many :serie, Workout.Workouts.Serie
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 8,max: 30)
    |> validate_length(:username, min: 3)
    |> unique_constraint(:username)
    |> hash_password()
  end
  def login_changeset(attrs) do
    %User{}
    |> cast(attrs, [:username, :password])
    |> validate_required([:username,:password])
  end

  defp hash_password(%Ecto.Changeset{} = changeset) do
    case changeset do
       %Ecto.Changeset{valid?: true, changes: %{password: password}}->
        put_change(changeset,:password,Argon2.hash_pwd_salt(password))
        _ ->
          changeset
    end
  end
end
