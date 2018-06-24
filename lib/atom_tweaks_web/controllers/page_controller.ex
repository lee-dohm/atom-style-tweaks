defmodule AtomTweaksWeb.PageController do
  @moduledoc """
  Handles requests for the root-level resources.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Tweaks.Tweak

  import Ecto.Query, only: [from: 2]

  @doc """
  Renders the root-level index page.
  """
  def index(conn, params) do
    type = params["type"]

    tweaks =
      Tweak
      |> Tweak.filter_by_type(type)
      |> from(
        order_by: [desc: :inserted_at],
        preload: [forked_from: [:user], user: []]
      )
      |> Repo.all()

    render(conn, "index.html", tweaks: tweaks, type: type)
  end

  @doc """
  Renders the about page.
  """
  def about(conn, _params) do
    render(conn, "about.html")
  end
end
