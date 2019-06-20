defmodule AtomTweaksWeb.PageController do
  @moduledoc """
  Handles requests for the root-level pages.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Releases
  alias AtomTweaks.Tweaks

  @doc """
  Renders the about page.
  """
  def about(conn, _params) do
    render(conn, "about.html")
  end

  @doc """
  Renders the home page.
  """
  def index(conn, params) do
    type = params["type"]
    tweaks = Tweaks.list_tweaks(type: type)

    render(conn, "index.html", tweaks: tweaks, type: type)
  end

  @doc """
  Renders the release notes index page.
  """
  def release_notes(conn, _params) do
    notes = Releases.list_notes()

    render(conn, "release_notes.html", notes: notes)
  end
end
