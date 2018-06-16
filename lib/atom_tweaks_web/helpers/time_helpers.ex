defmodule AtomTweaksWeb.TimeHelpers do
  @moduledoc """
  View helper functions for displaying time information.
  """
  use Phoenix.HTML

  @doc """
  Renders the `time-ago` element formatted to display the relative time between now and `from`.

  Also includes the `title` attribute containing the
  [ISO 8601-formatted](https://en.wikipedia.org/wiki/ISO_8601) timestamp that will be displayed on
  hover for people wanting to see the exact time instead of the approximation.
  """
  @spec relative_time(DateTime.t()) :: Phoenix.HTML.safe()
  def relative_time(from) do
    from_now = Timex.from_now(from, Gettext.get_locale(AtomTweaksWeb.Gettext))
    title = strip_fractional_seconds(from)

    content_tag(:"time-ago", from_now, title: title)
  end

  defp strip_fractional_seconds(from) do
    from
    |> to_string
    |> String.replace(~r/\.\d+$/, "")
  end
end
