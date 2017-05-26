defmodule AtomStyleTweaks.Router do
  use AtomStyleTweaks.Web, :router

  require Logger

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
    plug :authorize
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", AtomStyleTweaks do
    pipe_through :browser

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
    get "/logout", AuthController, :delete
  end

  scope "/", AtomStyleTweaks do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/about", PageController, :about

    get "/:name", UserController, :show

    get "/:name/tweaks/new", TweakController, :new
    post "/:name/tweaks/new", TweakController, :create
    get "/:name/tweaks/:id/edit", TweakController, :edit
    get "/:name/tweaks/:id", TweakController, :show
    post "/:name/tweaks/:id", TweakController, :update
    patch "/:name/tweaks/:id", TweakController, :update
    put "/:name/tweaks/:id", TweakController, :update
    delete "/:name/tweaks/:id", TweakController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", AtomStyleTweaks do
  #   pipe_through :api
  # end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  def assign_current_user(conn, _) do
    user = get_session(conn, :current_user)
    Logger.debug(fn -> "Current user = #{inspect user}" end)

    assign(conn, :current_user, user)
  end

  def authorize(conn, _) do
    assign(conn, :authorized?, authorized?(get_session(conn, :current_user)))
  end

  def authorized?(nil), do: false
  def authorized?(_), do: true

  def log_flash(conn, _params) do
    Logger.debug(fn -> "Flash info = #{get_flash(conn, :info)}" end)
    Logger.debug(fn -> "Flash error = #{get_flash(conn, :error)}" end)

    conn
  end

  def log_assigns(conn, _params) do
    Logger.debug("=== Assigns ===")
    Enum.each(conn.assigns, fn(assign) -> Logger.debug(inspect(assign)) end)
    Logger.debug("=== End Assigns ===")

    conn
  end
end
