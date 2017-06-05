defmodule AtomStyleTweaks.OcticonHelpers do
  @moduledoc """
  Helper functions for displaying [Octicons](https://octicons.github.com).
  """

  use Phoenix.HTML

  alias AtomStyleTweaks.Tweak

  @doc """
  Draws a normal-sized Octicon.
  """
  @spec octicon(Octicons.octicon_name, map) :: Phoenix.HTML.safe
  def octicon(name, options \\ %{})

  def octicon(atom, options) when is_atom(atom), do: octicon(Atom.to_string(atom), options)

  def octicon(name, options) do
    raw(Octicons.toSVG(name, options))
  end

  @doc """
  Draws an upsized Octicon (32px tall).
  """
  @spec mega_octicon(Octicons.octicon_name, map) :: Phoenix.HTML.safe
  def mega_octicon(name, options \\ %{})

  def mega_octicon(atom, options) when is_atom(atom), do: mega_octicon(Atom.to_string(atom), options)

  def mega_octicon(name, options) do
    new_opts = %{"height" => "32"}
               |> Map.merge(options)

    raw(Octicons.toSVG(name, new_opts))
  end

  @doc """
  Draws the appropriate Octicon for the given `tweak`.
  """
  @spec octicon_for(Tweak.t) :: Phoenix.HTML.safe
  def octicon_for(tweak = %Tweak{}) do
    tweak
    |> icon_for_tweak
    |> octicon
  end

  @doc """
  Draws the appropriate upsized Octicon for the given `tweak`.
  """
  @spec mega_octicon_for(Tweak.t) :: Phoenix.HTML.safe
  def mega_octicon_for(tweak = %Tweak{}) do
    tweak
    |> icon_for_tweak
    |> mega_octicon
  end

  defp icon_for_tweak(%{type: "init"}), do: :code
  defp icon_for_tweak(%{type: "style"}), do: :paintcan
end
