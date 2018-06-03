defmodule AtomTweaksWeb.ControllerHelpers do
  alias Phoenix.Controller

  @doc """
  Redirects back to the last user-navigated path.
  """
  def redirect_back(conn, opts \\ []) do
    Controller.redirect(conn, to: NavigationHistory.last_path(conn, opts))
  end
end
