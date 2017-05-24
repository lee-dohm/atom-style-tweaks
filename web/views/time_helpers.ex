defmodule AtomStyleTweaks.TimeHelpers do
  @moduledoc """
  Helper functions for dealing with time.
  """

  use Phoenix.HTML

  def relative_time(from) do
    content_tag(:"time-ago", Timex.from_now(from, Gettext.get_locale(AtomStyleTweaks.Gettext)), title: from)
  end
end
