defmodule AtomTweaksWeb.PlugHelpers do
  @moduledoc """
  Plug functions for various uses.
  """

  alias AtomTweaksWeb.ForbiddenUserError
  alias AtomTweaksWeb.NotLoggedInError

  @doc """
  A [function plug](https://hexdocs.pm/plug/readme.html#the-plug-conn-struct) used within a
  router or controller that verifies that there is a currently logged in user.

  ## Examples

  Ensures that there is a currently logged in user:

  ```
  plug :ensure_authenticated_user when action in [:create]
  ```
  """
  def ensure_authenticated_user(conn, _) do
    case conn.assigns[:current_user] do
      nil -> raise(NotLoggedInError, conn: conn)
      _ -> conn
    end
  end

  @doc """
  A [function plug](https://hexdocs.pm/plug/readme.html#the-plug-conn-struct) used within a
  router or controller that verifies that there is a currently logged in user.

  ## Examples

  Ensures that the logged in user is a site admin:

  ```
  plug :ensure_site_admin when action in [:create]
  ```
  """
  def ensure_site_admin(conn, _) do
    if conn.assigns[:current_user].site_admin do
      conn
    else
      raise(ForbiddenUserError, conn: conn)
    end
  end
end
