defmodule AtomTweaksWeb.Router do
  @moduledoc """
  Routes requests to the website to the appropriate controller.
  """
  use AtomTweaksWeb, :router

  use Plug.ErrorHandler
  use Sentry.Plug

  require Logger

  alias AtomTweaksWeb.HerokuMetadata
  alias AtomTweaksWeb.SlidingSessionTimeout

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:assign_current_user)
    plug(SlidingSessionTimeout)
    plug(NavigationHistory.Tracker)
    plug(HerokuMetadata, only: ["HEROKU_RELEASE_VERSION", "HEROKU_SLUG_COMMIT"])
    plug(Plug.Ribbon, [:dev, :staging, :test])
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", AtomTweaksWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/about", PageController, :about)
    get("/release-notes", PageController, :release_notes)

    resources("/tweaks", TweakController, except: [:index]) do
      resources("/forks", ForkController, only: [:create, :index])

      get("/stargazers", StargazerController, :index)
      post("/star", StarController, :toggle)
    end

    resources("/users", UserController, only: [:show]) do
      get("/stars", StarController, :index)
    end

    get("/users/:user_id/tweaks/:tweak_id", ObsoleteRouteController, :long_tweak_path_to_short)
  end

  scope "/auth", AtomTweaksWeb do
    pipe_through(:browser)

    get("/", AuthController, :index)
    get("/callback", AuthController, :callback)
    get("/logout", AuthController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", AtomTweaksWeb do
  #   pipe_through :api
  # end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  def assign_current_user(conn, _) do
    user = get_session(conn, :current_user)
    Logger.debug(fn -> "Current user = #{inspect(user)}" end)

    assign(conn, :current_user, user)
  end
end
