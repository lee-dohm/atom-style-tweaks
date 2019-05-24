defmodule AtomTweaks.Markdown do
  @moduledoc """
  A structure that represents a chunk of Markdown text.

  The structure contains both the raw Markdown `text` and the rendered `html`. Rendering the text
  using either `to_html/1` or `to_iodata/1` memoizes the
  rendered HTML in the structure.
  """
  alias AtomTweaksWeb.MarkdownEngine

  @type t :: %__MODULE__{text: String.t(), html: nil | String.t()}
  defstruct text: "", html: nil

  @typedoc """
  An `AtomTweaks.Markdown` struct or a string of Markdown text.
  """
  @type markdown :: %__MODULE__{} | String.t()

  @doc """
  Renders the supplied Markdown as HTML.

  ## Examples

  Render Markdown from a string:

  ```
  iex> AtomTweaks.Markdown.to_html("# Foo")
  "<h1>Foo</h1>\n"
  ```

  Render Markdown from an unrendered `Markdown` struct:

  ```
  iex> AtomTweaks.Markdown.to_html(%AtomTweaks.Markdown{text: "# Foo"})
  "<h1>Foo</h1>\n"
  ```

  Passes already rendered Markdown through unchanged:

  ```
  iex> AtomTweaks.Markdown.to_html(%AtomTweaks.Markdown{html: "<p>foo</p>"})
  "<p>foo</p>"
  ```

  Returns an empty string for anything that isn't a string or a `Markdown` struct:

  ```
  iex> AtomTweaks.Markdown.to_html(5)
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

  @doc """
  Renders a chunk of Markdown to its `iodata` representation.
  """
  @spec to_iodata(markdown) :: iodata
  def to_iodata(markdown = %__MODULE__{}), do: to_html(markdown)

  defimpl Phoenix.HTML.Safe do
    # credo:disable-for-lines:2
    def to_iodata(markdown = %AtomTweaks.Markdown{}) do
      AtomTweaks.Markdown.to_iodata(markdown)
    end
  end
end
