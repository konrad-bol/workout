defmodule WorkoutWeb.PageJSON do
  def register(%{user: user}) do
    %{
      message: "User registered successfully",
      user: %{
        id: user.id,
        username: user.username,
        password: user.password
      }
    }
  end
  def profil(%{user: user}) do
    %{
      message: "this is your user",
      user: %{
        id: user.id,
        username: user.username,
        password: user.password
      }
    }
  end
  def error(%{ error: error}) do
    %{
      message: "User registered failed",
      error: error
    }
  end
  def login(%{user: user}) do
    %{
      message: "User logged in successfully",
      user: %{
        id: user.id,
        username: user.username,
        password: user.password
      }
    }
  end
  def logout(%{message: message}) do
    %{message: message}
  end
end
