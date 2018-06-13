defmodule AtomTweaksWeb.PrimerHelpers do
  @moduledoc """
  View helper functions for generating elements that work with
  [GitHub's Primer](https://primer.github.io/) CSS framework.

  All functions can be used either within a template or composed together in code. Each function
  should always emit `t:Phoenix.HTML.safe/0` objects or throw an exception.
  """
  use Phoenix.HTML

  alias AtomTweaks.Accounts.User

  @doc """
  Renders the `avatar` element for the `user`.

  **See:** [Avatar element documentation](https://github.com/primer/primer/tree/master/modules/primer-avatars#basic-example)

  ## Options

  Valid options are:

  * `size` the value in pixels to use for both the width and height of the avatar image
  """
  @spec avatar(User.t(), Keword.t()) :: Phoenix.HTML.safe()
  def avatar(user, options \\ [])

  def avatar(user, []) do
    tag(:img, alt: user.name, class: "avatar", src: user.avatar_url)
  end

  def avatar(user, size: size) do
    tag(
      :img,
      alt: user.name,
      class: "avatar",
      src: append_query(user.avatar_url, %{s: size}),
      width: size,
      height: size
    )
  end

  @doc """
  Renders a `Counter` element.

  **See:** [Counter element documentation](https://github.com/primer/primer/tree/master/modules/primer-labels#counters)
  """
  @spec counter(non_neg_integer()) :: Phoenix.HTML.safe()
  def counter(count) do
    content_tag(:span, Integer.to_string(count), class: "Counter")
  end

  @doc """
  Renders a link that visually appears as a button.

  ## Options

  * `:to` - the URL to link to
  """
  @spec link_button(String.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def link_button(text, options \\ []) do
    options = Keyword.merge(options, type: "button")

    link(text, options)
  end

  @doc """
  Renders a menu element.

  **See:** [Menu element documentation](https://github.com/primer/primer/tree/master/modules/primer-navigation#menu)

  ## Example

  Slime template:

  ```
  = menu do
    = menu_item("Foo", "/path/to/foo", selected: true)
    = menu_item("Bar", "/path/to/bar")
  ```

  generates:

  ```html
  <nav class="menu">
    <a class="menu-item selected" href="/path/to/foo">Foo</a>
    <a class="menu-item" href="/path/to/bar">Bar</a>
  </nav>
  ```
  """
  @spec menu(Keyword.t()) :: Phoenix.HTML.safe()
  def menu(block)

  def menu(do: block) do
    content_tag(:nav, block, class: "menu")
  end

  @doc """
  Renders a menu item element.

  ## Options

  * `:octicon` - Renders an [Octicon](https://octicons.github.com) with the menu item
  * `:selected` - If `true`, renders the menu item as selected

  All other options are passed through to the underlying HTML `a` element.
  """
  @spec menu_item(String.t(), String.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def menu_item(text, link, options \\ []) do
    selected = options[:selected]

    class =
      "menu-item"
      |> append_class(options[:class])
      |> append_class(if selected, do: "selected", else: nil)

    tag_options =
      options
      |> Keyword.drop([:octicon, :selected])
      |> Keyword.put(:href, link)
      |> Keyword.put(:class, class)

    content =
      if options[:octicon] do
        [
          PhoenixOcticons.octicon(options[:octicon], width: 16),
          text
        ]
      else
        text
      end

    content_tag(:a, content, tag_options)
  end

  @doc """
  Renders an `UnderlineNav` element.

  The `underline_nav_item/3` function is used to generate the nav items within the nav element.

  **See:** [UnderlineNav element documentation](https://github.com/primer/primer/tree/master/modules/primer-navigation#underline-nav)

  ## Options

  All options are passed through to the underlying HTML `nav` element.

  ## Example

  Slime template:

  ```
  = underline_nav do
    = underline_nav_item "Foo", "/path/to/foo", selected: true
    = underline_nav_item "Bar", "/path/to/bar"
  ```

  generates:

  ```html
  <nav class="UnderlineNav">
    <div class="UnderlineNav-body">
      <a class="UnderlineNav-item selected" href="/path/to/foo">Foo</a>
      <a class="UnderlineNav-item" href="/path/to/bar">Bar</a>
    </div>
  </div>
  ```
  """
  @spec underline_nav(Keyword.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def underline_nav(options \\ [], block)

  def underline_nav(options, do: block) do
    class = append_class("UnderlineNav", options[:class])

    content_tag(:nav, class: class) do
      content_tag(:div, block, class: "UnderlineNav-body")
    end
  end

  @doc """
  Renders an `UnderlineNav-item` element.

  ## Options

  * `:counter` - When supplied with an integer value, renders a `Counter` element
  * `:selected` - When `true`, renders this item as selected

  All other options are passed through to the underlying HTML `a` element.
  """
  @spec underline_nav_item(String.t(), String.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def underline_nav_item(text, link, options \\ []) do
    count = options[:counter]
    selected = options[:selected]

    class =
      "UnderlineNav-item"
      |> append_class(options[:class])
      |> append_class(if selected, do: "selected", else: nil)

    tag_options =
      options
      |> Keyword.drop([:counter, :selected])
      |> Keyword.put(:class, class)

    tag_options = if selected, do: tag_options, else: Keyword.put(tag_options, :href, link)
    content = if count, do: [text, counter(count)], else: text

    content_tag(:a, content, tag_options)
  end

  defp append_class(base, nil), do: base
  defp append_class(base, ""), do: base
  defp append_class(base, class) when is_binary(class), do: base <> " " <> class

  defp append_query(avatar_url, map) do
    uri = URI.parse(avatar_url)

    new_query =
      uri.query
      |> URI.decode_query(map)
      |> URI.encode_query()

    uri
    |> Map.put(:query, new_query)
    |> to_string()
  end
end
