defmodule AtomTweaks.TweaksTest do
  use AtomTweaks.DataCase

  import Support.AssertHelpers
  import Support.SetupHelpers

  alias AtomTweaks.Accounts
  alias AtomTweaks.Tweaks
  alias AtomTweaks.Tweaks.Tweak

  setup [:insert_tweak]

  describe "fork_tweak" do
    setup [:insert_user]

    setup context do
      {:ok, tweak} = Tweaks.fork_tweak(context.tweak, context.user)

      {:ok, forked_tweak: tweak}
    end

    test "has the original tweak as the parent", context do
      assert context.forked_tweak.parent == context.tweak.id
    end

    test "is created by the new user", context do
      assert context.forked_tweak.created_by == context.user.id
    end

    test "copies the appropriate values", context do
      assert context.tweak.code == context.forked_tweak.code
      assert context.tweak.description == context.forked_tweak.description
      assert context.tweak.title == context.forked_tweak.title
      assert context.tweak.type == context.forked_tweak.type
    end

    test "cannot fork your own tweak", context do
      tweak = Repo.preload(context.tweak, [:user])
      {:error, changeset} = Tweaks.fork_tweak(tweak, tweak.user)

      assert error_on?(changeset, :created_by)
      assert error_messages(changeset, :created_by) == ["cannot fork your own tweak"]
    end
  end

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
