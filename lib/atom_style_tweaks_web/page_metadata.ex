defmodule AtomStyleTweaksWeb.PageMetadata do
  @moduledoc """
  A system for easily setting metadata for the page before it is rendered.
  """
  use Phoenix.HTML

  import Plug.Conn, only: [assign: 3]

  @doc """
  Renders the metadata for the page, if it was set.
  """
  @spec render(Plug.Conn.t) :: Phoenix.HTML.safe | nil
  def render(conn) do
    case conn.assigns[:page_metadata] do
      nil -> nil
      metadata ->
        Enum.map(metadata, fn({key, value}) -> tag(:meta, property: key, content: value) end)
    end
  end

  @doc """
  Sets the metadata for the page.
  """
  @spec set(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def set(conn, metadata) do
    metadata = Map.merge(%{
        "og:url": "#{conn.scheme}://#{conn.host}#{conn.request_path}",
        "og:site_name": Application.get_env(:atom_style_tweaks, :site_name)
      }, metadata)

    assign(conn, :page_metadata, metadata)
  end
end
