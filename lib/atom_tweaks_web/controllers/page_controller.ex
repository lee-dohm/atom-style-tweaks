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

    # credo:disable-for-lines:8
    tweaks =
      from(
        t in Tweak,
        where: is_nil(t.parent),
        order_by: [desc: :inserted_at],
        preload: [:user]
      )
      |> Tweak.filter_by_type(type)
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
