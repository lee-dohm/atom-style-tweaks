defmodule AtomTweaksWeb.UserController do
  @moduledoc """
  Handles requests for user resources.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts

  @doc """
  Shows the named user.
  """
  def show(conn, %{"id" => name}) do
    user = Accounts.get_user!(name)
    tweaks = Accounts.list_tweaks(user)
    star_count = Accounts.count_stars(user)
    tweak_count = Accounts.count_tweaks(user)

    render(
      conn,
      "show.html",
      user: user,
      tweaks: tweaks,
      tweak_count: tweak_count,
      star_count: star_count
    )
  end
end
