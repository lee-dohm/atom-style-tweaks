defmodule AtomTweaksWeb.PageView do
  use AtomTweaksWeb, :view

  alias AtomTweaksWeb.TweakView

  @doc """
  Get the appropriate title text based on the type of tweaks selected.
  """
  def tweak_title(nil), do: "All Tweaks"
  def tweak_title("init"), do: "Init Tweaks"
  def tweak_title("style"), do: "Style Tweaks"
end
