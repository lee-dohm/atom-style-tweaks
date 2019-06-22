defmodule AtomTweaksWeb.TokenController do
  @moduledoc """
  Handles all requests for user token routes.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts
  alias AtomTweaksWeb.ForbiddenUserError

  plug(:ensure_authenticated_user)
  plug(:ensure_site_admin)

  def index(conn, %{"user_id" => name}) do
    user = Accounts.get_user!(name)

    unless conn.assigns[:current_user].id == user.id do
      raise(ForbiddenUserError, conn: conn)
    end

    tokens = Accounts.list_tokens(user)
    star_count = Accounts.count_stars(user)
    tweak_count = Accounts.count_tweaks(user)

    render(
      conn,
      "index.html",
      user: user,
      tokens: tokens,
      star_count: star_count,
      tweak_count: tweak_count
    )
  end
end
