defmodule AtomStyleTweaks.OcticonHelpers do
  @moduledoc """
  Helper functions for displaying [Octicons](https://octicons.github.com).
  """

  use Phoenix.HTML

  def octicon(name) do
    content_tag(:span, "", class: "octicon octicon-#{name}")
  end

  def mega_octicon(name) do
    content_tag(:span, "", class: "mega-octicon octicon-#{name}")
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
