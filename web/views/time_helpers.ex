defmodule AtomStyleTweaks.TimeHelpers do
  use Phoenix.HTML

  @duration_pattern ~r/P((?<years>\d+)Y)?((?<months>\d+)M)?((?<days>\d+)D)?(T((?<hours>\d+)H)?((?<minutes>\d+)M)?((?<seconds>\d+)S)?)?/

  def relative_time(from) do
    content_tag(:"time-ago", Timex.from_now(from, Gettext.get_locale(AtomStyleTweaks.Gettext)), title: from)
  end
end
