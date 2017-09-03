defmodule AtomStyleTweaks.MarkdownEngine do
  @moduledoc """
  Custom engine for rendering Markdown in Slime templates.
  """
  @behaviour Slime.Parser.EmbeddedEngine

  @spec render(String.t | nil) :: String.t
  def render(text), do: render(text, [])

  @doc """
  Renders the given Markdown text into HTML.

  **See:** `Cmark.to_html/2`
  """
  @spec render(String.t | nil, Keyword.t) :: String.t
  def render(nil, options), do: render("", options)

  def render(text, _options) do
    Cmark.to_html(text, [:safe, :smart])
  end
end
