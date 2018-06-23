defmodule AtomTweaksWeb.PrimerHelpers do
  @moduledoc """
  View helper functions for generating elements that work with
  [GitHub's Primer](https://primer.github.io/) CSS framework.

  All functions can be used either within a template or composed together in code. Each function
  should always emit `t:Phoenix.HTML.safe/0` objects or throw an exception.
  """
  use Phoenix.HTML

  require AtomTweaksWeb.Gettext

  import AtomTweaksWeb.Gettext, only: [gettext: 1]

  alias AtomTweaks.Accounts.User

  @typedoc """
  The application name as an atom.
  """
  @type app_name :: atom

  defmodule MissingConfigurationError do
    defexception [:missing_keys]

    def exception(key) when is_atom(key), do: exception([key])

    def exception(keys) when is_list(keys) do
      %__MODULE__{missing_keys: keys}
    end

    def message(%{missing_keys: missing_keys}) do
      "application configuration missing: #{inspect(missing_keys)}"
    end
  end

  @doc """
  Renders the `avatar` element for the `user`.

  **See:** [Avatar element documentation](https://github.com/primer/primer/tree/master/modules/primer-avatars#basic-example)

  ## Options

  * `:size` - value in pixels to use for both the width and height of the avatar image
  """
  @spec avatar(User.t(), Keword.t()) :: Phoenix.HTML.safe()
  def avatar(user, options \\ [])

  def avatar(user, options) do
    size = options[:size] || 35

    class = append_class("avatar", options[:class])

    tag_options =
      options
      |> Keyword.drop([:size])
      |> Keyword.put(:alt, user.name)
      |> Keyword.put(:class, class)
      |> Keyword.put(:src, append_query(user.avatar_url, s: size))
      |> Keyword.put(:width, size)
      |> Keyword.put(:height, size)

    tag(:img, tag_options)
  end

  @doc """
  Renders the GitHub-style `<> with ♥ by [author link]` footer item.

  Retrieves the author's name and URL from the application configuration for the default application
  for the current module. See `code_with_heart/2` for more information.
  """
  @spec code_with_heart() :: Phoenix.HTML.safe()
  def code_with_heart do
    code_with_heart(Application.get_application(__MODULE__))
  end

  @doc """
  Renders the GitHub-style `<> with ♥ by [author link]` footer item.

  Retrieves the author's name and URL from the application configuration before passing to
  `code_with_heart/3`. This information can be added to the application configuration by adding the
  following to your `config.exs`:

  ```
  config :app_name,
    code_with_heart: [
      name: "Author's name",
      url: "https://example.com"
    ]
  ```

  Raises a `AtomTweaksWeb.PrimerHelpers.MissingConfigurationError` if any of the required
  application configuration information is not specified and this function is called.

  If passed two strings instead of an atom and a keyword list, this function will assume that you
  mean to call `code_with_heart/3` with no options and do so for you.
  """
  @spec code_with_heart(atom, Keyword.t()) :: Phoenix.HTML.safe()
  def code_with_heart(app_name, options \\ [])

  def code_with_heart(app_name, options)

  def code_with_heart(app_name, options) when is_atom(app_name) and is_list(options) do
    config = Application.get_env(app_name, :code_with_heart)
    name = config[:name]
    url = config[:url]

    unless name && url, do: raise MissingConfigurationError, :code_with_heart

    code_with_heart(name, url, options)
  end

  def code_with_heart(name, url) when is_binary(name) and is_binary(url),
    do: code_with_heart(name, url, [])

  @doc """
  Renders the GitHub-style `<> with ♥ by [author link]` footer item.

  The text in this element is intentionally left untranslated because the form of the element is
  intended to be recognizable in its specific format.

  ## Options

  All options are passed to the underlying HTML `a` element.

  ## Examples

  ```
  Phoenix.HTML.safe_to_string(AtomTweaksWeb.PrimerHelpers.code_with_heart("Author's Name", "https://example.com"))
  #=> "<svg .../> with <svg .../> by <a href=\"https://example.com\">Author's Name</a>"
  ```
  """
  @spec code_with_heart(String.t(), String.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def code_with_heart(name, url, options) do
    link_options = Keyword.merge([to: url, class: "link-gray-dark"], options)

    html_escape([
      PhoenixOcticons.octicon(:code),
      " with ",
      PhoenixOcticons.octicon(:heart),
      " by ",
      link(name, link_options)
    ])
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
  Renders a link to the project on GitHub.

  Retrieves the project name or URL from the application configuration for the default application.
  """
  def github_link(options \\ [])

  def github_link(options), do: github_link(options, [])

  @doc """
  Renders a link to the project on GitHub.

  If the first parameter is an atom, it retrieves the project name or URL from the application
  configuration. Otherwise, the project can be either the GitHub `owner/project` identifier or the
  full GitHub URL.

  This configuration information can be added to the application configuration by adding the
  following to your `config.exs`:

  ```
  config :app_name,
    github_link: "owner/name"
  ```

  If the configuration information is missing and the first parameter is an atom, a
  `AtomTweaksWeb.PrimerHelpers.MissingConfigurationError` is raised.

  ## Options

  All options are passed to the underlying HTML `a` element.
  """
  @spec github_link(String.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def github_link(app_name_or_project, options)

  def github_link(options, _no_options) when is_list(options) do
    github_link(Application.get_application(__MODULE__), options)
  end

  def github_link(app_name, options) when is_atom(app_name) do
    url = Application.get_env(app_name, :github_link)

    unless url, do: raise MissingConfigurationError, :github_link

    github_link(url, options)
  end

  def github_link(project, options) when is_binary(project) do
    # Prepend the `https://github.com/` if only the name with owner is specified
    url = if project =~ ~r{^[^/]+/[^/]+$}, do: "https://github.com/#{project}", else: project

    link_options =
      Keyword.merge(
        [
          to: url,
          "aria-label": gettext("View this project on GitHub"),
          class: "link-gray-dark tooltipped tooltipped-n"
        ],
        options
      )

    link(link_options) do
      PhoenixOcticons.octicon("mark-github")
    end
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

  defp append_query(avatar_url, options) do
    map = Enum.into(options, %{})
    uri = URI.parse(avatar_url)

    new_query =
      uri.query ||
        ""
        |> URI.decode_query(map)
        |> URI.encode_query()

    uri
    |> Map.put(:query, new_query)
    |> to_string()
  end
end
