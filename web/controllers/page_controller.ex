defmodule AtomStyleTweaks.PageController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Tweak

  def index(conn, params) do
    query = Tweak
            |> Tweak.sorted
            |> Tweak.preload

    query = if params["type"], do: Tweak.by_type(query, params["type"]), else: query
    tweaks = Repo.all(query)

    render(conn, "index.html", tweaks: tweaks, params: params)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
