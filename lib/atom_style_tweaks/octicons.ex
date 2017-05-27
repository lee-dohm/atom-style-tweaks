defmodule AtomStyleTweaks.Octicons do
  @moduledoc """
  Mimics the interface of the primer/octicons Node module in Elixir.
  """

  @doc false
  def start_link do
    {:ok, data} =
      with {:ok, text} <- File.read("./node_modules/octicons/build/data.json"),
           do: Poison.decode(text)

    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  @doc """
  Retrieves the description of the octicon.
  """
  def icon(key) do
    key
    |> get_data
    |> Map.merge(default_options(key))
    |> Map.merge(%{"symbol" => key})
  end

  @doc """
  Gets the SVG representation of the octicon.
  """
  def toSVG(icon, options \\ %{})

  def toSVG(key, options) when is_binary(key), do: toSVG(icon(key), options)

  def toSVG(icon_data, options) when is_map(icon_data) do
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
