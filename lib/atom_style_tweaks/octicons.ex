defmodule AtomStyleTweaks.Octicons do
  @moduledoc """
  Octicons are a scalable set of icons handcrafted with <3 by GitHub.

  This module is designed to operate identically to the [Node module][octicons-node] of the same
  name.

  [octicons-node]: https://www.npmjs.com/package/octicons
  """

  @type t :: map

  @doc false
  def start_link do
    data =
      with {:ok, text} <- File.read("./node_modules/octicons/build/data.json"),
           {:ok, data} <- Poison.decode(text),
           do: data

    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  @doc """
  Retrieves the attributes of the icon.
  """
  @spec icon(AtomStyleTweaks.octicon_name) :: t
  def icon(name) when is_atom(name), do: icon(Atom.to_string(name))

  def icon(name) do
    name
    |> get_data
    |> Map.merge(default_options(name))
    |> Map.merge(%{"symbol" => name})
  end

  @doc """
  Returns the SVG tag that renders the icon.

  ## Options

  * `:"aria-label"` Aria label for the SVG tag. When `aria-label` is specified, the `aria-hidden`
    attribute is removed.
  * `:class` CSS class text to add to the classes already present
  * `:height` Height in pixels to render the icon at. If only `height` is specified, width is
    calculated to maintain the aspect ratio.
  * `:width` Width in pixels to render the icon at. If only `width` is specified, height is
    calculated to maintain the aspect ratio.
  """
  @spec toSVG(AtomStyleTweaks.octicon_name | t, keyword) :: String.t
  def toSVG(icon, options \\ [])

  def toSVG(name, options) when is_atom(name) or is_binary(name), do: toSVG(icon(name), options)

  def toSVG(icon_data, options) when is_list(options), do: toSVG(icon_data, Enum.into(options, %{}))

  def toSVG(icon_data = %{}, options) do
    symbol = icon_data["symbol"]
    path = icon_data["path"]

    "<svg #{html_attributes(symbol, options)}>#{path}</svg>"
  end

  defp aria(map, %{"aria-label" => label}) do
    map
    |> Map.merge(%{"aria-label" => label})
    |> Map.merge(%{"role" => "img"})
    |> Map.delete("aria-hidden")
  end

  defp aria(map, _), do: map

  defp class(map, key, %{"class" => option_class}) do
    map
    |> Map.merge(
      %{
        "class" => String.trim("octicons octicons-#{key} #{option_class}")
      }
    )
  end

  defp class(map, _, _), do: map

  defp dimensions(map, _, %{"height" => height, "width" => width}) do
    map
    |> Map.merge(%{"height" => height, "width" => width})
  end

  defp dimensions(map, key, %{"height" => height}) do
    data = get_data(key)

    map
    |> Map.merge(
      %{
        "height" => height,
        "width" => parse_int(height) * parse_int(data["width"]) / parse_int(data["height"])
      }
    )
  end

  defp dimensions(map, key, %{"width" => width}) do
    data = get_data(key)

    map
    |> Map.merge(
      %{
        "height" => parse_int(width) * parse_int(data["height"]) / parse_int(data["width"]),
        "width" => width
      }
    )
  end

  defp dimensions(map, _, _), do: map

  defp get_data(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  defp default_options(key) do
    data = get_data(key)

    %{
      "version" => "1.1",
      "width" => data["width"],
      "height" => data["height"],
      "viewBox" => "0 0 #{data["width"]} #{data["height"]}",
      "class" => "octicons octicons-#{key}",
      "aria-hidden" => "true"
    }
  end

  defp html_attributes(key, options) do
    key
    |> get_data
    |> Map.merge(default_options(key))
    |> Map.merge(options)
    |> dimensions(key, options)
    |> class(key, options)
    |> aria(options)
    |> Map.delete("keywords")
    |> Map.delete("path")
    |> Map.to_list
    |> Enum.map(fn({key, value}) -> "#{key}=\"#{value}\"" end)
    |> Enum.join(" ")
    |> String.trim
  end

  defp parse_int(text) do
    {int, _} = Integer.parse(text)

    int
  end
end
