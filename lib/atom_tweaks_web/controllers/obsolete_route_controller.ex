defmodule AtomTweaksWeb.ObsoleteRouteController do
  @moduledoc """
  Handles redirections for obsolete router paths.
  """
  use AtomTweaksWeb, :controller

  @doc """
  Redirects the old-style long tweak paths to the new shorter ones.

  For example: `/users/foo/tweaks/df15c988-f262-4c03-bb73-dcfd4a8161ee` becomes
  `/tweaks/df15c988-f262-4c03-bb73-dcfd4a8161ee`.
  """
  @spec long_tweak_path_to_short(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def long_tweak_path_to_short(conn, params)

  def long_tweak_path_to_short(conn, %{"tweak_id" => id}) do
    redirect(conn, to: Routes.tweak_path(conn, :show, id))
  end
end
