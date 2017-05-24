defmodule AtomStyleTweaks.MarkdownEngine do
  @behaviour Slime.Parser.EmbeddedEngine

  def render(text, _options) do
    Cmark.to_html(text, [:safe, :smart])
  end
end
