defmodule AtomTweaksWeb.PageMetadata do
  @moduledoc """
  A system for easily setting metadata for the page before it is rendered.

  If you assign some metadata to the page before it is rendered:

  ```
  iex> PageMetadata.add(conn, foo: "bar")
  iex> hd(conn.assigns.page_metadata)
  [foo: "bar"]
  ```

  And add the `PageMetadata.render/1` call to the `head` section of the layout template:

  ```elixir
  <%= PageMetadata.render(@conn) %>
  ```

  It will show up in the rendered page:

  ```html
  <html>
    <head>
      <meta foo="bar">
    </head>
    <body>
    </body>
  </html>
  ```
  """

  use Phoenix.HTML

  alias AtomTweaksWeb.PageMetadata.Metadata
  alias Plug.Conn

  @doc """
  Adds metadata to the page.

  The metadata for any type that implements the `AtomTweaksWeb.PageMetadata.Metadata` protocol can
  be added to a page.
  """
  @spec add(Plug.Conn.t(), Metadata.t() | nil) :: Plug.Conn.t()
  def add(conn, metadata)

  def add(conn, nil), do: conn

  def add(conn, metadata) do
    do_add(conn, Metadata.to_metadata(metadata))
  end

  @doc """
  Renders the metadata for the page, if it was set.

  It renders each item of metadata as an individual `meta` tag. This function should be called in
  the `head` section of the page layout template, typically
  `app_name_web/templates/layout/app.html.eex`.
  """
  @spec render(Plug.Conn.t()) :: Phoenix.HTML.safe() | nil
  def render(conn) do
    case conn.assigns[:page_metadata] do
      nil -> nil
      metadata -> Enum.map(metadata, fn datum -> tag(:meta, datum) end)
    end
  end

  defp default_metadata(conn) do
    [
      [property: "og:url", content: "#{conn.scheme}://#{conn.host}#{conn.request_path}"],
      [property: "og:site_name", content: Application.get_env(:atom_tweaks, :site_name)]
    ]
  end

  defp do_add(conn, []), do: Conn.assign(conn, :page_metadata, get(conn))

  defp do_add(conn, list) do
    if Keyword.keyword?(list) do
      Conn.assign(conn, :page_metadata, [list | get(conn)])
    else
      Enum.reduce(list, conn, &add(&2, &1))
    end
  end

  defp get(conn) do
    conn.assigns[:page_metadata] || default_metadata(conn)
  end
end
