defmodule AtomStyleTweaks.Markdown do
  @moduledoc """
  A structure that represents a chunk of Markdown to be rendered.
  """
  alias AtomStyleTweaksWeb.MarkdownEngine

  @type t :: %__MODULE__{text: String.t(), html: nil | String.t()}
  defstruct text: "", html: nil

  @type markdown :: %__MODULE__{} | String.t()

  @doc """
  Renders the supplied Markdown as HTML.

  ## Examples

  Render Markdown from a string:

  ```
  iex> AtomStyleTweaks.Markdown.to_html("# Foo")
  "<h1>Foo</h1>\n"
  ```

  Render Markdown from an unrendered `Markdown` struct:

  ```
  iex> AtomStyleTweaks.Markdown.to_html(%AtomStyleTweaks.Markdown{text: "# Foo"})
  "<h1>Foo</h1>\n"
  ```

  Passes already rendered Markdown through unchanged:

  ```
  iex> AtomStyleTweaks.Markdown.to_html(%AtomStyleTweaks.Markdown{html: "<p>foo</p>"})
  "<p>foo</p>"
  ```

  Returns an empty string for anything that isn't a string or a `Markdown` struct:

  ```
  iex> AtomStyleTweaks.Markdown.to_html(5)
  ""
  ```
  """
  @spec to_html(markdown) :: binary
  def to_html(markdown)

  def to_html(%__MODULE__{html: html}) when is_binary(html), do: html
  def to_html(%__MODULE__{text: text}) when is_binary(text), do: to_html(text)

  def to_html(binary) when is_binary(binary) do
    MarkdownEngine.render(binary)
  end

  def to_html(_), do: ""

  def to_iodata(markdown = %__MODULE__{}), do: to_html(markdown)

  defimpl Phoenix.HTML.Safe do
    def to_iodata(markdown = %AtomStyleTweaks.Markdown{}) do
      AtomStyleTweaks.Markdown.to_iodata(markdown)
    end
  end
end
