defmodule AtomTweaksWeb.Router do
  use AtomTweaksWeb, :router
  use Plug.ErrorHandler

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
    plug(HerokuMetadata, only: ["HEROKU_RELEASE_VERSION", "HEROKU_SLUG_COMMIT"])
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/auth", AtomTweaksWeb do
    pipe_through(:browser)

    get("/", AuthController, :index)
    get("/callback", AuthController, :callback)
    get("/logout", AuthController, :delete)
  end

  scope "/", AtomTweaksWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/about", PageController, :about)

    resources "/users", UserController, only: [:show] do
      resources("/tweaks", TweakController)
    end
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

  def log_flash(conn, _params) do
    Logger.debug(fn -> "Flash info = #{get_flash(conn, :info)}" end)
    Logger.debug(fn -> "Flash error = #{get_flash(conn, :error)}" end)

    conn
  end

  def log_assigns(conn, _params) do
    Logger.debug("=== Assigns ===")
    Enum.each(conn.assigns, fn assign -> Logger.debug(inspect(assign)) end)
    Logger.debug("=== End Assigns ===")

    conn
  end

  # defp handle_errors(_, %{kind: :error, reason: %NoRouteError{}}), do: :ok
  #
  # defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stacktrace}) do
  #   conn =
  #     conn
  #     |> Conn.fetch_cookies()
  #     |> Conn.fetch_query_params()
  #
  #   conn_data = %{
  #     "request" => %{
  #       "cookies" => conn.req_cookies,
  #       "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
  #       "user_ip" => conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
  #       "headers" => Enum.into(conn.req_headers, %{}),
  #       "params" => conn.params,
  #       "method" => conn.method
  #     },
  #     "server" => %{
  #       "pid" => System.get_env("MY_SERVER_PID"),
  #       "host" => "#{System.get_env("MY_HOSTNAME")}:#{System.get_env("MY_PORT")}",
  #       "root" => System.get_env("MY_APPLICATION_PATH")
  #     }
  #   }
  # end
end
