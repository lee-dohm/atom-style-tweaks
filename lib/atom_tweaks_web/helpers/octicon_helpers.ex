defmodule AtomTweaksWeb.OcticonHelpers do
  @moduledoc """
  Helper functions for displaying [Octicons](https://octicons.github.com).
  """

  use Phoenix.HTML

  alias AtomTweaks.Tweaks.Tweak

  @doc """
  Draws the appropriate Octicon for the given `tweak`.

  ## Options

  All options are passed through to `PhoenixOcticons.octicon/2` and are then passed to
  `Octicons.to_svg/2`.
  """
  @spec octicon_for(Tweak.t(), keyword) :: Phoenix.HTML.safe()
  def octicon_for(tweak = %Tweak{}, options \\ []) do
    tweak
    |> icon_for_tweak
    |> PhoenixOcticons.octicon(options)
  end

  @doc """
  Draws the appropriate upsized Octicon for the given `tweak`.

  ## Options

  All options are passed through to `PhoenixOcticons.octicon/2` and are then passed to
  `Octicons.to_svg/2`.
  """
  @spec mega_octicon_for(Tweak.t(), keyword) :: Phoenix.HTML.safe()
  def mega_octicon_for(tweak = %Tweak{}, options \\ []) do
    tweak
    |> icon_for_tweak
    |> PhoenixOcticons.mega_octicon(options)
  end

  defp icon_for_tweak(%{type: "init"}), do: :code
  defp icon_for_tweak(%{type: "style"}), do: :paintcan
end
