defmodule AtomTweaks.Markdown do
  @moduledoc """
  A structure that represents a chunk of Markdown text in memory.

  For the database type, see `AtomTweaks.Ecto.Markdown` instead.

  The structure contains both the raw Markdown `text` and, potentially, the rendered `html`. Upon
  a request to render the structure using either `to_html/1` or `to_iodata/1`, the `html` field is
  given preference and returned unchanged, if available. If the `html` value is `nil`, then the
  contents of the `text` field are rendered using `AtomTweaksWeb.MarkdownEngine.render/1` and
  returned.

  This type requires special handling in forms because Phoenix's form builder functions call
  `Phoenix.HTML.html_escape/1` on all field values, which returns the `html` field on this type. But
  what we want when we show an `AtomTweaks.Markdown` value in a form is the `text` field.
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

  defimpl Jason.Encoder do
    def encode(markdown = %AtomTweaks.Markdown{}, opts) do
      Jason.Encode.string(markdown.text, opts)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(markdown = %AtomTweaks.Markdown{}) do
      AtomTweaks.Markdown.to_iodata(markdown)
    end
  end
end
