defmodule AtomStyleTweaks.MarkdownEngine do
  @moduledoc """
  Custom engine for rendering Markdown in Slime templates.

  **Warning:** Does not work in production!
  """
  @behaviour Slime.Parser.EmbeddedEngine

  def render(text, _options) do
    Cmark.to_html(text, [:safe, :smart])
  end
end
