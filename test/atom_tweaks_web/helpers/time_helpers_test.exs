defmodule AtomTweaksWeb.TimeHelpersTest do
  use AtomTweaksWeb.HelperCase

  import AtomTweaksWeb.TimeHelpers

  @doc """
  Ensures that there is a fractional second component no matter what time it is when the tests are
  executed.
  """
  def ensure_nonzero_microseconds(time = %{microsecond: {0, _}}) do
    %{time | microseconds: {7_000, 6}}
  end

  def ensure_nonzero_microseconds(time), do: time

  describe "relative_time" do
    setup do
      now = ensure_nonzero_microseconds(NaiveDateTime.utc_now())
      five_minutes_ago = NaiveDateTime.add(now, 60 * -5)

      {:ok, five_minutes_ago: five_minutes_ago}
    end

    test "renders the element", context do
      time_ago = render(relative_time(context.five_minutes_ago))

      title_text =
        context.five_minutes_ago
        |> NaiveDateTime.truncate(:second)
        |> to_string

      assert find(time_ago, "time-ago")
      assert attribute(time_ago, "title") == [title_text]
      assert text(time_ago) == "5 minutes ago"
    end
  end
end
