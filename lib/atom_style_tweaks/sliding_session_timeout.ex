defmodule AtomStyleTweaks.SlidingSessionTimeout do
  @moduledoc """
  Times out the session after a period of inactivity.

  The default timeout is one hour. This can be configured in the application config where the
  timeout is given as a number of seconds.

  ```
  config :my_app, AtomStyleTweaks.SlidingSessionTimeout,
    timeout: 1_234
  ```
  """
  import Plug.Conn

  alias Phoenix.Controller

  require Logger

  def init, do: init([])
  def init(nil), do: init([])

  def init(opts) do
    defaults = init_defaults()
    Keyword.merge(defaults, opts)
  end

  def call(conn, opts) do
    timeout_at = get_session(conn, :timeout_at)

    if timeout_at && now() > timeout_at do
      conn
      |> logout_user
      |> Controller.redirect(to: "/auth?from=#{conn.request_path}")
      |> halt
    else
      new_timeout = calculate_timeout(opts[:timeout])

      put_session(conn, :timeout_at, new_timeout)
    end
  end

  defp get_app, do: Application.get_application(__MODULE__)

  defp init_defaults do
    [timeout: 3_600]
    |> Keyword.merge(Application.get_env(get_app(), __MODULE__) || [])
  end

  defp logout_user(conn) do
    conn
    |> clear_session
    |> configure_session([:renew])
    |> assign(:timed_out?, true)
  end

  defp now, do: DateTime.to_unix(DateTime.utc_now())

  defp calculate_timeout(timeout), do: now() + timeout
end
