defmodule AtomStyleTweaks.PageController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Tweak

  def index(conn, params) do
    query = Tweak
            |> Tweak.sorted
            |> Tweak.preload

    query = if params["type"], do: Tweak.by_type(query, params["type"]), else: query
    page = Repo.paginate(query, params)

    render conn, :index,
      tweaks: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      params: params
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
