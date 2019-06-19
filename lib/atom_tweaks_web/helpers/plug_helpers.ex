defmodule AtomTweaksWeb.PlugHelpers do
  @moduledoc """
  [Function plugs](https://hexdocs.pm/plug/readme.html#the-plug-conn-struct) to be used within
  either a router or controller.
  """

  alias AtomTweaksWeb.ForbiddenUserError
  alias AtomTweaksWeb.NotLoggedInError

  @doc """
  Verifies that there is a currently logged in user.

  Raises `AtomTweaksWeb.NotLoggedInError` when there is no user logged in.

  ## Examples

  Ensures that there is a currently logged in user:

  ```
  plug :ensure_authenticated_user when action in [:create]
  ```
  """
  @spec ensure_authenticated_user(Plug.Conn.t(), Map.t()) :: Plug.Conn.t() | no_return
  def ensure_authenticated_user(conn, options)

  def ensure_authenticated_user(conn, _) do
    case conn.assigns[:current_user] do
      nil -> raise(NotLoggedInError, conn: conn)
      _ -> conn
    end
  end

  @doc """
  Verifies that the currently logged in user is a site admin.

  Raises `AtomTweaksWeb.ForbiddenUserError` when the current user is not a site admin.

  ## Examples

  Ensures that the logged in user is a site admin:

  ```
  plug :ensure_site_admin when action in [:create]
  ```
  """
  @spec ensure_site_admin(Plug.Conn.t(), Map.t()) :: Plug.Conn.t() | no_return
  def ensure_site_admin(conn, options)

  def ensure_site_admin(conn, _) do
    if conn.assigns[:current_user].site_admin do
      conn
    else
      raise(ForbiddenUserError, conn: conn)
    end
  end
end
