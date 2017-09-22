defmodule AtomStyleTweaksWeb.TimeHelpers do
  @moduledoc """
  Helper functions for dealing with time.
  """

  use Phoenix.HTML

  def relative_time(from) do
    from_now = Timex.from_now(from, Gettext.get_locale(AtomStyleTweaksWeb.Gettext))
    title = strip_fractional_seconds(from)

    content_tag(:"time-ago", from_now, title: title)
  end

  defp strip_fractional_seconds(from) do
    from
    |> to_string
    |> String.replace(~r/\.\d+$/, "")
  end
end
