defmodule AtomStyleTweaks.PageController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Tweak

  def index(conn, _params) do
    tweaks = Repo.all(from t in Tweak, limit: 10, order_by: [desc: :updated_at], preload: [:user])

    render(conn, "index.html", tweaks: tweaks)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
