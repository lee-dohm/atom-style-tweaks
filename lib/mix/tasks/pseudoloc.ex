defmodule Mix.Tasks.Pseudoloc do
  @moduledoc """
  Creates a pseudolocalized translation of the Gettext data files.

  ```
  $ mix pseudoloc priv/gettext
  ```
  """

  @shortdoc "Creates a pseudolocalized translation"

  use Mix.Task

  alias Gettext.PO
  alias Mix.Shell.IO

  @type alternatives :: %{optional(String.t()) => list(String.t())}
  @type range :: {non_neg_integer, non_neg_integer}
  @type ranges :: list(range)

  @doc """
  Get the ranges within the text that need to be localized.

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

  A string consisting of multiple interpolations:

  ```
  iex> Mix.Tasks.Pseudoloc.get_ranges("foo%{bar}baz%{quux}quuux")
  [{0, 3}, {9, 3}, {19, 5}]
  ```
  """
  @spec get_ranges(String.t()) :: ranges
  def get_ranges(text) do
    interpolation_ranges = Regex.scan(~r(%\{[^}\s\t\n]+\}), text, return: :index)

    do_get_ranges(text, 0, interpolation_ranges, [])
  end

  @doc """
  Localizes `text` with the default alternatives.

  See `localize_string/2` for details.
  """
  @spec localize_string(String.t()) :: String.t()
  def localize_string(text), do: localize_string(text, default_alternatives())

  def localize_string(_text, _alternatives) do
  end

  def localize_range(_text, _range, _alternatives) do
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
    Code.eval_file(Path.join(__DIR__, "pseudoloc_alternatives.exs"))
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
    IO.info("Pseduolocalize #{path}")

    data =
      path
      |> PO.parse_file!()
      |> PO.dump()

    File.write!(path, data)
  end
end
