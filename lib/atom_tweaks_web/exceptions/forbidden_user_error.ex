defmodule AtomTweaksWeb.ForbiddenUserError do
  @moduledoc """
  Exception raised when accessing a route that requires authorizations the current user does not
  have.
  """

  alias AtomTweaksWeb.ForbiddenUserError

  defexception plug_status: 403, message: "forbidden", conn: nil

  def exception(opts) do
    conn = Keyword.fetch!(opts, :conn)
    path = "/" <> Enum.join(conn.path_info, "/")

    %ForbiddenUserError{message: "You do not have permissions to access #{path}", conn: conn}
  end
end
