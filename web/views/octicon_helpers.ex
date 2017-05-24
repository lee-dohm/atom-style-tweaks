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
end
