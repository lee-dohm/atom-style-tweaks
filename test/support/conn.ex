defmodule Support.Conn do
  @moduledoc """
  Functions for testing `Plug.Conn` values.
  """

  @doc """
  Fetches the value for `key` from the `t:Plug.Conn/0` assigns.
  """
  def fetch_assign(conn, key) do
    {:ok, value} = Map.fetch(conn.assigns, key)

    value
  end
end
