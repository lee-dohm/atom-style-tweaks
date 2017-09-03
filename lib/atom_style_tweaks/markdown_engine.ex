defmodule AtomStyleTweaks.MarkdownEngine do
  @moduledoc """
  Custom engine for rendering Markdown in Slime templates.
  """
  @behaviour Slime.Parser.EmbeddedEngine

  @doc """
  Renders the given Markdown text into HTML.

  **See:** `Cmark.to_html/2`
  """
  def render(text, _options) do
    Cmark.to_html(text, [:safe, :smart])
  end
end
