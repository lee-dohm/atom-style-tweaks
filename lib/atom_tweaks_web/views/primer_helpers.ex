defmodule AtomTweaksWeb.PrimerHelpers do
  @moduledoc """
  Helper functions for generating elements that work with [Primer](https://primer.github.io/).
  """
  use Phoenix.HTML

  @doc """
  Renders a `Counter` element.

  **See:** <https://github.com/primer/primer/tree/master/modules/primer-labels#counters>
  """
  def counter(count) do
    content_tag(:span, Integer.to_string(count), class: "Counter")
  end

  @doc """
  Generates a link button with the given text and options.

  ## Options

  * `:to` - the URL to link to
  """
  def link_button(text, options \\ []) do
    options = Keyword.merge(options, type: "button")

    link(text, options)
  end

  @doc """
  Renders an `UnderlineNav` element.

  **See:** <https://github.com/primer/primer/tree/master/modules/primer-navigation#underline-nav>
  """
  def underline_nav(options \\ [], do: block) do
    class =
      "UnderlineNav"
      |> append_class(options[:class])

    content_tag(:nav, class: class) do
      content_tag(:div, block, class: "UnderlineNav-body")
    end
  end

  @doc """
  Renders an `UnderlineNav-item` element.

  **See:** <https://github.com/primer/primer/tree/master/modules/primer-navigation#underline-nav>

  ## Options

  * `:counter` - When supplied with an integer value, renders a `Counter` element
  * `:selected` - When `true`, renders this item as selected

  All other options are passed through to the actual HTML element.
  """
  def underline_nav_item(text, link, options \\ []) do
    selected = options[:selected]

    class =
      "UnderlineNav-item"
      |> append_class(options[:class])
      |> append_class(if selected, do: "selected", else: nil)

    tag_options =
      options
      |> Keyword.drop([:counter, :selected])
      |> Keyword.put(:class, class)

    tag_options =
      if selected do
        tag_options
      else
        Keyword.put(tag_options, :href, link)
      end

    content =
      if options[:counter] do
        [
          text,
          counter(options[:counter])
        ]
      else
        text
      end

    content_tag(:a, content, tag_options)
  end

  defp append_class(base, nil), do: base
  defp append_class(base, ""), do: base
  defp append_class(base, class) when is_binary(class), do: base <> " " <> class
end
