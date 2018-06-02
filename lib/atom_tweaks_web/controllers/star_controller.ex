defmodule AtomTweaksWeb.StarController do
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts

  def index(conn, %{"user_id" => name}) do
    user = Accounts.get_user!(name)
    stars = Accounts.list_stars(user)

    render(conn, "index.html", user: user, stars: stars)
  end
end
