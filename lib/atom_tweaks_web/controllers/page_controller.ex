defmodule AtomTweaksWeb.PageController do
  @moduledoc """
  Handles requests for the root-level resources.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Tweaks
  alias AtomTweaks.Tweaks

  @doc """
  Renders the root-level index page.
  """
  def index(conn, params) do
    type = params["type"]
    tweaks = Tweaks.list_tweaks(type: type)

    render(conn, "index.html", tweaks: tweaks, type: type)
  end

  @doc """
  Renders the about page.
  """
  def about(conn, _params) do
    render(conn, "about.html")
  end
end
