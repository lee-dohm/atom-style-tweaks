defmodule AtomTweaksWeb.StarController do
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts

  def index(conn, %{"user_id" => name}) do
    user = Accounts.get_user!(name)
    stars = Accounts.list_stars(user)
    star_count = Accounts.count_stars(user)
    tweak_count = Accounts.count_tweaks(user)

    render(
      conn,
      "index.html",
      user: user,
      stars: stars,
      star_count: star_count,
      tweak_count: tweak_count
    )
  end
end
