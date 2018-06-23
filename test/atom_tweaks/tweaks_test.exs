defmodule AtomTweaks.TweaksTest do
  use AtomTweaks.DataCase

  import Support.SetupHelpers

  alias AtomTweaks.Accounts
  alias AtomTweaks.Tweaks
  alias AtomTweaks.Tweaks.Tweak

  setup [:insert_tweak]

  describe "get_tweak!" do
    test "retrieve existing tweak", context do
      tweak = Tweaks.get_tweak!(context.tweak.id)

      assert tweak.id == context.tweak.id
    end

    test "retrieve non-existent tweak raises NoResultsError", _context do
      assert_raise Ecto.NoResultsError, fn ->
        Tweaks.get_tweak!(UUID.uuid4())
      end
    end
  end

  describe "stargazers" do
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
end
