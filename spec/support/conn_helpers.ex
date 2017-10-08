defmodule Conn.Helpers do
  def log_in_as(conn, user), do: Plug.Test.init_test_session(conn, %{current_user: user})
end
