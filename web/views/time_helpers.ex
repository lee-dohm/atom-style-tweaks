defmodule AtomStyleTweaks.TimeHelpers do
  use Phoenix.HTML

  @duration_pattern ~r/P((?<years>\d+)Y)?((?<months>\d+)M)?((?<days>\d+)D)?(T((?<hours>\d+)H)?((?<minutes>\d+)M)?((?<seconds>\d+)S)?)?/

  def relative_time(from) do
    content_tag(:"time-ago", relative_time_text(from), title: from)
  end

  defp format_interval_text({:seconds, seconds}) when seconds < 10, do: "just now"
  defp format_interval_text({:seconds, seconds}), do: "#{seconds} seconds ago"
  defp format_interval_text({:minutes, minutes}), do: "#{minutes} minutes ago"
  defp format_interval_text({:hours, hours}), do: "#{hours} hours ago"
  defp format_interval_text({:days, days}), do: "#{days} days ago"
  defp format_interval_text({:months, months}), do: "#{months} months ago"
  defp format_interval_text({:years, years}), do: "#{years} years ago"

  defp get_largest_unit(%{"years" => years}) when years !== "", do: {:years, years}
  defp get_largest_unit(%{"months" => months}) when months !== "", do: {:months, months}
  defp get_largest_unit(%{"days" => days}) when days !== "", do: {:days, days}
  defp get_largest_unit(%{"hours" => hours}) when hours !== "", do: {:hours, hours}
  defp get_largest_unit(%{"minutes" => minutes}) when minutes !== "", do: {:minutes, minutes}
  defp get_largest_unit(%{"seconds" => seconds}) when seconds !== "", do: {:seconds, seconds}
  defp get_largest_unit(_), do: {:seconds, 0}

  defp to_duration_text(from) do
    duration = Timex.now()
               |> Timex.diff(from, :duration)
               |> Timex.Duration.to_string

    @duration_pattern
    |> Regex.named_captures(duration)
  end

  defp relative_time_text(time) do
    time
    |> to_duration_text
    |> get_largest_unit
    |> format_interval_text
  end
end
