defmodule WorkoutWeb.Router do
  use WorkoutWeb, :router
  alias WorkoutWeb.Plug.PlugUser
  alias WorkoutWeb.Plug.PlugWorkout

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WorkoutWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plug.CSRFProtection
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug PlugUser
  end
  pipeline :workout do
    plug :accepts, ["json"]
    plug :fetch_session
    plug PlugWorkout
  end

  scope "/", WorkoutWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", WorkoutWeb do
    pipe_through :api

    post "/register", UserController, :register
    post "/login", UserController, :login
    post "/logout", UserController, :logout

  end
  scope "/api/workout", WorkoutWeb do
    pipe_through [:workout, :browser]

    get "/menu", PageController, :menu
    get "/register_workout", PageController, :register_workout
    get "/profile", PageController, :profil
    get "/stats", PageController, :stats
    post "/submit_the_workout", PageController, :submit_workout
    post "/add_reps", PageController, :add_reps
    post "/submit_stats", PageController, :submit_stats
  end

  # Other scopes may use custom stacks.
  # scope "/api", WorkoutWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:workout, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WorkoutWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
