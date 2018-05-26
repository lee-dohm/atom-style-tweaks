defmodule AtomStyleTweaksWeb.OcticonHelpers do
  @moduledoc """
  Helper functions for displaying [Octicons](https://octicons.github.com).
  """

  use Phoenix.HTML

  alias AtomStyleTweaksWeb.Tweak

  @doc """
  Draws the appropriate Octicon for the given `tweak`.
  """
  @spec octicon_for(Tweak.t()) :: Phoenix.HTML.safe()
  def octicon_for(tweak = %Tweak{}) do
    tweak
    |> icon_for_tweak
    |> PhoenixOcticons.octicon()
  end

  @doc """
  Draws the appropriate upsized Octicon for the given `tweak`.
  """
  @spec mega_octicon_for(Tweak.t()) :: Phoenix.HTML.safe()
  def mega_octicon_for(tweak = %Tweak{}) do
    tweak
    |> icon_for_tweak
    |> PhoenixOcticons.mega_octicon()
  end

  defp icon_for_tweak(%{type: "init"}), do: :code
  defp icon_for_tweak(%{type: "style"}), do: :paintcan
end
