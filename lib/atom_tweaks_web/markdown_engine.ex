defmodule AtomTweaksWeb.MarkdownEngine do
  @moduledoc """
  Renders Markdown into HTML.

  Besides using [CommonMark](http://commonmark.org) to render Markdown into HTML, it also links
  at-mentions to user profile pages.
  """
  alias AtomTweaks.Accounts

  @behaviour Slime.Parser.EmbeddedEngine

  @mention_pattern ~r{
      (?:^|\W)                   # beginning of string or non-word char
      @((?>[a-z0-9][a-z0-9-]*))  # @username
      (?!\/)                     # without a trailing slash
      (?=
        \.+[ \t\W]|              # dots followed by space or non-word character
        \.+$|                    # dots at end of line
        [^0-9a-zA-Z_.]|          # non-word character except dot
        $                        # end of line
      )
    }ix

  @mention_link_pattern ~r{<a href="([^"]*)">(@[a-zA-Z0-9][a-zA-Z0-9-]*)</a>}

  @doc """
  Renders the given Markdown `text` into HTML with the default set of options.
  """
  @spec render(iodata() | nil) :: String.t()
  def render(text), do: render(text, [])

  @doc """
  Renders the given Markdown `text` into HTML according to `options`.

  **See:** `Cmark.to_html/2`

  ## Options

  Currently, the `:safe`, `:smart`, and `:validate_utf8` options are hard-coded. All supplied
  options are ignored.
  """
  @spec render(iodata() | nil, Keyword.t()) :: String.t()
  def render(text, options)

  def render(nil, options), do: render("", options)
  def render(list, options) when is_list(list), do: render(Enum.join(list), options)

  # Represents the Markdown rendering pipeline.
  def render(text, _options) do
    text
    |> Cmark.to_commonmark(&replace_mention(&1, at_mention_funcs()), [:validate_utf8])
    |> Cmark.to_html([:safe, :smart])
    |> String.replace(@mention_link_pattern, ~s{<a class="at-mention" href="\\1">\\2</a>})
  end

  @doc false
  def replace_mention(nil, _), do: nil
  def replace_mention("", _), do: ""

  def replace_mention(text, funcs) do
    Regex.replace(@mention_pattern, text, &replace_mention(&1, &2, funcs))
  end

  # Builds a list of functions to check for applicable at-mention replacements.
  defp at_mention_funcs do
    [
      fn _, name ->
        if Accounts.get_user(name) do
          "[@#{name}](/users/#{name})"
        end
      end
    ]
  end

  defp first_replacement_wins(match, name, funcs) do
    Enum.find_value(funcs, fn func -> func.(match, name) end)
  end

  defp preceding_character(match) do
    case String.at(match, 0) do
      "@" -> ""
      char -> char
    end
  end

  defp replace_mention(match, name, funcs) do
    char = preceding_character(match)

    case first_replacement_wins(match, name, funcs) do
      nil -> match
      replace_with -> "#{char}#{replace_with}"
    end
  end
end
