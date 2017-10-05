defmodule AtomStyleTweaksWeb.OpenGraph do
  @moduledoc """
  Functions for handling Facebook Open Graph data and inserting the appropriate tags into pages.
  """
  alias AtomStyleTweaksWeb.Router
  alias Phoenix.Controller

  import Plug.Conn, only: [assign: 3]

  require Logger

  use Phoenix.HTML

  @doc """
  Renders the Open Graph metadata, if it exists.
  """
  @spec render_metadata(Plug.Conn.t) :: Phoenix.HTML.safe
  def render_metadata(conn) do
    case conn.assigns[:open_graph_metadata] do
      nil -> nil
      metadata ->
        Enum.map(metadata, fn({key, value}) -> tag(:meta, property: key, content: value) end)
    end
  end

  @doc """
  Sets the Open Graph metadata for the current request.
  """
  @spec set_metadata(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def set_metadata(conn, metadata) do
    metadata = Map.merge(%{
        "og:url": Controller.current_url(conn),
        "og:site_name": Application.get_env(:atom_style_tweaks, :site_name)
      }, metadata)

    assign(conn, :open_graph_metadata, metadata)
  end
end
