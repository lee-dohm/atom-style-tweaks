defmodule AtomTweaks.TweaksTest do
  use AtomTweaks.DataCase

  import Support.SetupHelpers

  alias AtomTweaks.Accounts
  alias AtomTweaks.Tweaks
  alias AtomTweaks.Tweaks.Tweak

  setup [:insert_tweak]

  test "returns the list of stargazers", context do
    {:ok, _} = Accounts.star_tweak(context.user, context.tweak)

    stargazers = Tweaks.list_stargazers(context.tweak)

    assert length(stargazers) == 1
    assert hd(stargazers) == context.user
  end

  test "list stargazers gives an empty list when given an invalid tweak", _context do
    stargazers = Tweaks.list_stargazers(%Tweak{})

    assert Enum.empty?(stargazers)
  end
end
