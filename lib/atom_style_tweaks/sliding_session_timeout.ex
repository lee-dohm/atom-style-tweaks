defmodule AtomStyleTweaks.SlidingSessionTimeout do
  @moduledoc """
  Times out the session after a period of inactivity.

  Defaults to timing out after one hour.
  """
  import Plug.Conn

  def init, do: [timeout: 3_600]
  def init(opts), do: Keyword.merge([timeout: 3_600], opts)

  def call(conn, opts) do
    timeout_at = get_session(conn, :timeout_at)
    if timeout_at && now() > timeout_at do
      logout_user(conn)
    else
      put_session(conn, :timeout_at, calculate_timeout(opts[:timeout]))
    end
  end

  defp logout_user(conn) do
    conn
    |> clear_session
    |> configure_session([:renew])
    |> assign(:timed_out, true)
  end

  defp now, do: DateTime.to_unix(DateTime.utc_now())

  defp calculate_timeout(timeout), do: now() + timeout
end
