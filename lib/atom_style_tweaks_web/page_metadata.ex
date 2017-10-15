defmodule AtomStyleTweaksWeb.PageMetadata do
  @moduledoc """
  A system for easily setting metadata for the page before it is rendered.

  If you assign some metadata to the page before it is rendered:

  ```
  iex> PageMetadata.add(conn, foo: "bar")
  iex> hd(conn.assigns.page_metadata)
  [foo: "bar"]
  ```

  And add the `PageMetadata.render/1` call to the layout template:

  ```html
  <html>
    <head>
      <%= PageMetadata.render(@conn) %>
  ```

  It will show up in the rendered page:

  ```html
  <html>
    <head>
      <meta foo="bar">
  ```
  """
  use Phoenix.HTML

  import Plug.Conn, only: [assign: 3]

  @doc """
  Adds an item of metadata for the page.

  An item of metadata is a keyword list of attributes and their values to be rendered as a `meta`
  tag in the page. A list of keyword lists can be supplied to add multiple items of metadata to be
  rendered.
  """
  @spec add(Plug.Conn.t, list | keyword(String.t)) :: Plug.Conn.t
  def add(conn, []), do: assign(conn, :page_metadata, get(conn))
  def add(conn, list) do
    if Keyword.keyword?(list) do
      assign(conn, :page_metadata, [list | get(conn)])
    else
      Enum.reduce(list, conn, &(add(&2, &1)))
    end
  end

  @doc """
  Renders the metadata for the page, if it was set.

  It renders each item of metadata as an individual `meta` tag. This function should be called in
  the `head` section of the page layout template, typically
  `app_name_web/templates/layout/app.html.eex`.
  """
  @spec render(Plug.Conn.t) :: Phoenix.HTML.safe | nil
  def render(conn) do
    case conn.assigns[:page_metadata] do
      nil -> nil
      metadata -> Enum.map(metadata, fn(datum) -> tag(:meta, datum) end)
    end
  end

  defp default_metadata(conn) do
    [
      [property: "og:url", content: "#{conn.scheme}://#{conn.host}#{conn.request_path}"],
      [property: "og:site_name", content: Application.get_env(:atom_style_tweaks, :site_name)]
    ]
  end

  defp get(conn) do
    conn.assigns[:page_metadata] || default_metadata(conn)
  end
end
