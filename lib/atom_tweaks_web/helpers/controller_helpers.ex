defmodule AtomTweaksWeb.ControllerHelpers do
  @moduledoc """
  Helper functions for `Controllers`.
  """
  alias Phoenix.Controller

  @doc """
  Redirects back to the last user-navigated (in other words HTTP `GET`) path.
  """
  def redirect_back(conn, opts \\ []) do
    Controller.redirect(conn, to: NavigationHistory.last_path(conn, opts))
  end
end
