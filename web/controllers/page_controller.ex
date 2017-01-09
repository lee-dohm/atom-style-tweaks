defmodule AtomStyleTweaks.PageController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Style

  def index(conn, _params) do
    styles = Repo.all(from s in Style, limit: 10, order_by: [desc: :updated_at], preload: [:user])

    render(conn, "index.html", styles: styles)
  end
end
