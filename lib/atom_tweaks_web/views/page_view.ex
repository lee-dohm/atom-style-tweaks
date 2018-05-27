defmodule AtomTweaksWeb.PageView do
  use AtomTweaksWeb, :view

  alias AtomTweaksWeb.TweakView

  @doc """
  Get the appropriate title text based on the type of tweaks selected.
  """
  def tweak_title(nil), do: Gettext.gettext(AtomTweaksWeb.Gettext, "All Tweaks")
  def tweak_title("init"), do: Gettext.gettext(AtomTweaksWeb.Gettext, "Init Tweaks")
  def tweak_title("style"), do: Gettext.gettext(AtomTweaksWeb.Gettext, "Style Tweaks")
end
