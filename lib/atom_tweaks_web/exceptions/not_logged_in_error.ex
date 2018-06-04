defmodule AtomTweaksWeb.NotLoggedInError do
  @moduledoc """
  Exception raised when accessing a route that requires being logged in when you're not.
  """
  alias AtomTweaksWeb.NotLoggedInError

  defexception plug_status: 401, message: "unauthorized", conn: nil

  def exception(opts) do
    conn = Keyword.fetch!(opts, :conn)
    path = "/" <> Enum.join(conn.path_info, "/")

    %NotLoggedInError{message: "Logged out users cannot access #{path}", conn: conn}
  end
end
