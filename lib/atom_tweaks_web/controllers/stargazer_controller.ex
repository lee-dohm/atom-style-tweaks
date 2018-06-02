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
    tweak = Tweaks.get!(tweak_id)
    stargazers = Tweaks.list_stargazers(tweak)

    render(conn, "index.html", stargazers: stargazers, tweak: tweak)
  end
end
