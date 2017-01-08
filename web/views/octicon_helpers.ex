defmodule AtomStyleTweaks.OcticonHelpers do
  use Phoenix.HTML

  def octicon(name) do
    content_tag(:span, "", class: "octicon octicon-#{name}")
  end

  def mega_octicon(name) do
    content_tag(:span, "", class: "mega-octicon octicon-#{name}")
  end
end
