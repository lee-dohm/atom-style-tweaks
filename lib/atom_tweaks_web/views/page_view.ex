defmodule AtomTweaksWeb.PageView do
  use AtomTweaksWeb, :view

  require AtomTweaksWeb.Gettext

  import AtomTweaksWeb.Gettext, only: [gettext: 1]

  alias AtomTweaksWeb.TweakView

  @doc """
  Get the appropriate title text based on the type of tweaks selected.
  """
  def tweak_title(nil), do: gettext("All Tweaks")
  def tweak_title("init"), do: gettext("Init Tweaks")
  def tweak_title("style"), do: gettext("Style Tweaks")
end
