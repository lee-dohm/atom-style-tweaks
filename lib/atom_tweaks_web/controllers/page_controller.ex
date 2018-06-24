defmodule AtomTweaksWeb.PageController do
  @moduledoc """
  Handles requests for the root-level resources.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Tweaks.Tweak

  import Ecto.Query

  @doc """
  Renders the root-level index page.
  """
  def index(conn, params) do
    type = params["type"]

    query =
      from(
        t in Tweak,
        order_by: [desc: :inserted_at],
        preload: [forked_from: [:user], user: []]
      )

    query = Tweak.by_type(query, type)
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
