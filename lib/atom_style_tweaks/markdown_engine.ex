defmodule AtomStyleTweaks.MarkdownEngine do
  @moduledoc """
  Custom engine for rendering Markdown in Slime templates.
  """
  alias AtomStyleTweaks.User

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

  @spec render(String.t | nil) :: String.t
  def render(text), do: render(text, [])

  @doc """
  Renders the given Markdown text into HTML.

  **See:** `Cmark.to_html/2`
  """
  @spec render(String.t | nil, Keyword.t) :: String.t
  def render(nil, options), do: render("", options)

  def render(text, _options) do
    funcs = [
      fn (_, name) ->
        if User.exists?(name) do
          "[**@#{name}**](/users/#{name})"
        end
      end
    ]

    text
    |> Cmark.to_commonmark(&(replace_mention(&1, funcs)), [:validate_utf8])
    |> Cmark.to_html([:safe, :smart])
  end

  def replace_mention(nil, _), do: nil
  def replace_mention("", _), do: ""

  def replace_mention(text, funcs) do
    Regex.replace(@mention_pattern, text, &(replace_mention(&1, &2, funcs)))
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
