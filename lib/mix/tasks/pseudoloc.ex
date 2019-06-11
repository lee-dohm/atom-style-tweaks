defmodule Mix.Tasks.Pseudoloc do
  @moduledoc """
  Creates a [pseudolocalized](https://en.wikipedia.org/wiki/Pseudolocalization) translation of the
  `Gettext` data files.

  ```
  $ mix pseudoloc priv/gettext
  ```

  Because this module is designed to work with `Gettext`, it specifically ignores
  [interpolated](https://hexdocs.pm/gettext/Gettext.html#module-interpolation) sections of the
  strings it localizes.
  """

  use Mix.Task

  alias Gettext.PO
  alias Gettext.PO.PluralTranslation
  alias Gettext.PO.Translation
  alias Mix.Shell

  @interpolation_pattern ~r/%\{[^}\s\t\n]+\}/

  @shortdoc "Creates a pseudolocalized translation"

  @typedoc """
  A mapping of individual graphemes to a list of alternate representations.
  """
  @type alternatives :: %{optional(String.t()) => list(String.t())}

  @typedoc """
  Represents a range of text within a string by starting index and length.
  """
  @type range :: {non_neg_integer, non_neg_integer}

  @doc """
  Gets the ranges within the text that need to be localized.

  In other words, the ranges of the text that are not interpolations.

  Returns a list of tuples containing the index and length of each range to be localized.

  ## Examples

  A string with no interpolations:

  ```
  iex> Mix.Tasks.Pseudoloc.get_ranges("foo")
  [{0, 3}]
  ```

  A string consisting of only interpolations:

  ```
  iex> Mix.Tasks.Pseudoloc.get_ranges("%{foo}")
  []
  ```

  A string containing multiple interpolations:

  ```
  iex> Mix.Tasks.Pseudoloc.get_ranges("foo%{bar}baz%{quux}quuux")
  [{0, 3}, {9, 3}, {19, 5}]
  ```
  """
  @spec get_ranges(String.t()) :: [range]
  def get_ranges(text) do
    interpolation_ranges = Regex.scan(@interpolation_pattern, text, return: :index)

    do_get_ranges(text, 0, interpolation_ranges, [])
  end

  @doc """
  Localizes the `grapheme` if there are valid `alternatives`.

  ## Examples

  Returns the grapheme unchanged if there are no alternatives:

  ```
  iex> Mix.Tasks.Pseudoloc.localize_grapheme("a", %{"b" => ["ḅ"]})
  "a"
  ```

  Returns a random alternative if they exist:

  ```
  iex> Mix.Tasks.Pseudoloc.localize_grapheme("a", %{"a" => ["α"]})
  "α"
  ```

  ```
  iex> alts = ["1", "2", "3"]
  iex> Mix.Tasks.Pseudoloc.localize_grapheme("a", %{"a" => alts}) in alts
  true
  ```
  """
  @spec localize_grapheme(String.t(), alternatives) :: String.t()
  def localize_grapheme(grapheme, alternatives) do
    case Map.has_key?(alternatives, grapheme) do
      false -> grapheme
      true -> Enum.random(alternatives[grapheme])
    end
  end

  @doc """
  Localizes `text` within the `range` with the `alternatives`.

  ## Examples

  ```
  iex> Mix.Tasks.Pseudoloc.localize_range("foo", {1, 1}, %{"o" => ["ṓ"]})
  "fṓo"
  ```
  """
  @spec localize_range(String.t(), range, alternatives) :: String.t()
  def localize_range(text, range, alternatives)

  def localize_range(text, {_start, length}, _alternatives) when length <= 0, do: text

  def localize_range(text, {start, length}, alternatives) do
    range = Range.new(start, start + length - 1)

    {_, result} =
      Enum.reduce(range, {:cont, text}, fn elem, {_, text} ->
        {:cont, localize_grapheme_at(text, elem, alternatives)}
      end)

    result
  end

  @doc """
  Localizes `text` with the default alternatives.

  See `localize_string/2` for details.
  """
  @spec localize_string(String.t()) :: String.t()
  def localize_string(text), do: localize_string(text, default_alternatives())

  @doc """
  Localizes `text` with the given `alternatives`.

  ## Examples

  Localizing the non-interpolated sections of a string:

  ```
  iex> alternatives = %{"a" => ["α"], "f" => ["ϝ"], "u" => ["ṵ"]}
  iex> text = "foo%{bar}baz%{quux}quuux"
  iex> Mix.Tasks.Pseudoloc.localize_string(text, alternatives)
  "ϝoo%{bar}bαz%{quux}qṵṵṵx"
  ```
  """
  @spec localize_string(String.t(), alternatives) :: String.t()
  def localize_string(text, alternatives) do
    ranges = get_ranges(text)

    {_, result} =
      Enum.reduce(ranges, {:cont, text}, fn range, {_, text} ->
        {:cont, localize_range(text, range, alternatives)}
      end)

    result
  end

  @impl Mix.Task
  @doc false
  def run(args)

  def run([]) do
    Mix.raise(
      "Must be supplied with the directory where the gettext POT files are stored, typically priv/gettext"
    )
  end

  def run(args) do
    gettext_path = hd(args)
    pseudo_path = Path.join(gettext_path, "ps/LC_MESSAGES")
    File.mkdir_p!(pseudo_path)

    Mix.Task.run("gettext.extract")
    Mix.Task.run("gettext.merge", args)

    pseudo_path
    |> get_source_files()
    |> Enum.each(&localize_file/1)
  end

  defp cleanup_ranges(ranges) do
    ranges
    |> Enum.reverse()
    |> Enum.reject(fn elem -> match?({_, 0}, elem) end)
  end

  defp default_alternatives do
    {map, _} = Code.eval_file(Path.join(__DIR__, "pseudoloc_alternatives.exs"))

    map
  end

  defp do_get_ranges(text, last_pos, interpolation_ranges, translate_ranges)

  defp do_get_ranges(text, last_pos, [], translate_ranges) do
    result =
      if last_pos < String.length(text) do
        [{last_pos, String.length(text) - last_pos} | translate_ranges]
      else
        translate_ranges
      end

    cleanup_ranges(result)
  end

  defp do_get_ranges(text, last_pos, [head | tail], translate_ranges) do
    [{start, length}] = head

    do_get_ranges(text, start + length, tail, [{last_pos, start - last_pos} | translate_ranges])
  end

  defp get_source_files(path) do
    Path.wildcard(Path.join(path, "*.po"))
  end

  defp localize_file(path) do
    Shell.IO.info("Pseduolocalize #{path}")

    data =
      path
      |> PO.parse_file!()
      |> update_translations()
      |> PO.dump()

    File.write!(path, data)
  end

  defp localize_grapheme_at(text, at, alternatives) do
    before_text = String.slice(text, 0, at)
    after_text = String.slice(text, at + 1, String.length(text))

    Enum.join([before_text, localize_grapheme(String.at(text, at), alternatives), after_text])
  end

  defp update_translation(translation = %Translation{}) do
    localized_text = localize_string(hd(translation.msgid))

    %Translation{translation | msgstr: [localized_text]}
  end

  defp update_translation(translation = %PluralTranslation{}) do
    localized_singular = localize_string(hd(translation.msgid))
    localized_plural = localize_string(hd(translation.msgid_plural))

    {_, localized_msgstr} =
      Enum.reduce(Map.keys(translation.msgstr), {:cont, %{}}, fn key, {_, map} ->
        if key == 0 do
          {:cont, Map.put(map, 0, [localized_singular])}
        else
          {:cont, Map.put(map, key, [localized_plural])}
        end
      end)

    %PluralTranslation{translation | msgstr: localized_msgstr}
  end

  defp update_translations(po = %PO{}) do
    localized = Enum.map(po.translations, fn translation -> update_translation(translation) end)

    %PO{po | translations: localized}
  end
end
