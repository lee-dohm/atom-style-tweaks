defmodule AtomTweaksWeb.Admin.RootController do
  @moduledoc """
  Handles routes for the root of the admin page space.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Logs

  def main(conn, params)

  def main(conn, _params) do
    entries = Logs.list_entries()

    render(conn, "main.html", entries: entries)
  end
end
