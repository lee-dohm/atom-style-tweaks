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
    stargazers =
      tweak_id
      |> Tweaks.get!()
      |> Tweaks.list_stargazers()

    render(conn, "index.html", stargazers: stargazers)
  end
end
