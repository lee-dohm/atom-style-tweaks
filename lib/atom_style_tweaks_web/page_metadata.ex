defmodule AtomStyleTweaksWeb.PageMetadata do
  use Phoenix.HTML

  import Plug.Conn, only: [assign: 3]

  def render(conn) do
    case conn.assigns[:page_metadata] do
      nil -> nil
      metadata ->
        Enum.map(metadata, fn({key, value}) -> tag(:meta, property: key, content: value) end)
    end
  end

  def set(conn, metadata) do
    metadata = Map.merge(%{
        "og:url": "#{conn.scheme}://#{conn.host}#{conn.request_path}",
        "og:site_name": Application.get_env(:atom_style_tweaks, :site_name)
      }, metadata)

    assign(conn, :page_metadata, metadata)
  end
end
