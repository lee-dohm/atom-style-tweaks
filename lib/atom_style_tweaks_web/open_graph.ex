defmodule AtomStyleTweaksWeb.OpenGraph do
  @moduledoc """
  Functions for handling Facebook Open Graph data and inserting the appropriate tags into pages.
  """

  import Plug.Conn, only: [assign: 3]

  require Logger

  use Phoenix.HTML

  def render_metadata(conn) do
    case conn.assigns[:open_graph_metadata] do
      nil -> nil
      metadata ->
        Enum.map(metadata, fn({key, value}) -> tag(:meta, property: key, content: value) end)
    end
  end

  def set_metadata(conn, metadata) do
    metadata = Map.merge(%{
        "og:url": AtomStyleTweaksWeb.Router.Helpers.url(conn) <> conn.request_path,
        "og:site_name": Application.get_env(:atom_style_tweaks, :site_name)
      }, metadata)

    assign(conn, :open_graph_metadata, metadata)
  end
end
