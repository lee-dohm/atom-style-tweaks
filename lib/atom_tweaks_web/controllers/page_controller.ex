defmodule AtomTweaksWeb.PageController do
  @moduledoc """
  Handles requests for the root-level resources.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Tweaks.Tweak

  @doc """
  Renders the root-level index page.
  """
  def index(conn, params) do
    type = params["type"]

    query =
      Tweak
      |> Tweak.sorted()
      |> Tweak.preload()

    query = if type, do: Tweak.by_type(query, type), else: query
    tweaks = Repo.all(query)

    render(conn, "index.html", tweaks: tweaks, type: type)
  end

  @doc """
  Renders the about page.
  """
  def about(conn, _params) do
    render(conn, "about.html")
  end
end
