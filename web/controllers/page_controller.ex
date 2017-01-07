defmodule AtomStyleTweaks.PageController do
  use AtomStyleTweaks.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
