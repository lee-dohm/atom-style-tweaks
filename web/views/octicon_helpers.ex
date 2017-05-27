defmodule AtomStyleTweaks.OcticonHelpers do
  @moduledoc """
  Helper functions for displaying [Octicons](https://octicons.github.com).
  """

  use Phoenix.HTML

  alias AtomStyleTweaks.Octicons

  def octicon(atom) when is_atom(atom), do: octicon(Atom.to_string(atom))

  def octicon(name) do
    raw(Octicons.toSVG(name))
  end

  def mega_octicon(atom) when is_atom(atom), do: mega_octicon(Atom.to_string(atom))

  def mega_octicon(name) do
    raw(Octicons.toSVG(name, %{"height" => "32"}))
  end

  def octicon_for_tweak(tweak) do
    tweak
    |> icon_for_tweak
    |> octicon
  end

  def mega_octicon_for_tweak(tweak) do
    tweak
    |> icon_for_tweak
    |> mega_octicon
  end

  defp icon_for_tweak(%{type: "init"}), do: :code
  defp icon_for_tweak(%{type: "style"}), do: :paintcan
end
