defmodule AtomTweaksWeb.StargazerController do
  @moduledoc """
  Handles requests for tweak stargazer information.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Tweaks

  @doc """
  Displays the list of a tweak's stargazers.
  """
  def index(conn, %{"tweak_id" => tweak_id}) do
    tweak = Tweaks.get_tweak!(tweak_id)
    stargazers = Tweaks.list_stargazers(tweak)

    starred = Tweaks.is_starred?(tweak, conn.assigns.current_user)

    render(conn, "index.html", stargazers: stargazers, starred: starred, tweak: tweak)
  end
end
