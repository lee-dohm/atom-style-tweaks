defmodule AtomTweaks.TweaksTest do
  use AtomTweaks.DataCase

  import Support.Changeset
  import Support.Setup

  alias Ecto.Query

  alias AtomTweaks.Accounts
  alias AtomTweaks.Tweaks
  alias AtomTweaks.Tweaks.Tweak

  describe "fork_tweak" do
    setup [:insert_tweak, :insert_user]

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
      assert length(error_messages(changeset, :created_by)) == 1
      assert "cannot fork your own tweak" in error_messages(changeset, :created_by)
    end
  end

  describe "get_tweak!" do
    setup [:insert_tweak]

    test "retrieves an existing tweak", context do
      tweak = Tweaks.get_tweak!(context.tweak.id)

      assert tweak.id == context.tweak.id
    end

    test "retrieving a non-existent tweak raises NoResultsError", _context do
      assert_raise Ecto.NoResultsError, fn ->
        Tweaks.get_tweak!(UUID.uuid4())
      end
    end
  end

  describe "list_forks" do
    setup [:insert_user_with_tweaks, :fork_tweak]

    test "returns the list of forks", context do
      forks = Tweaks.list_forks(context.forked_tweak)

      assert length(forks) == 1
      assert hd(forks).id == context.fork_tweak.id
    end
  end

  describe "list_stargazers" do
    setup [:insert_tweak]

    test "returns the list of stargazers", context do
      {:ok, _} = Accounts.star_tweak(context.user, context.tweak)

      stargazers = Tweaks.list_stargazers(context.tweak)

      assert length(stargazers) == 1
      assert context.user in stargazers
    end

    test "list stargazers gives an empty list when given an invalid tweak", _context do
      stargazers = Tweaks.list_stargazers(%Tweak{})

      assert Enum.empty?(stargazers)
    end
  end

  describe "list_tweaks" do
    setup [:insert_user_with_tweaks, :fork_tweak, :insert_init_tweak, :insert_style_tweak]

    test "returns a list of tweaks", _context do
      tweaks = Tweaks.list_tweaks()

      assert length(tweaks) == 5
    end

    test "can include forks", _context do
      tweaks = Tweaks.list_tweaks(forks: true)

      assert length(tweaks) == 6
    end

    test "can filter by tweak type", _context do
      tweaks = Tweaks.list_tweaks(type: "init")

      init_count =
        Repo.one(
          Query.from(
            t in Tweak,
            where: t.type == "init",
            where: is_nil(t.parent),
            select: count(t.id)
          )
        )

      assert length(tweaks) == init_count
    end

    test "can filter by user", context do
      tweaks = Tweaks.list_tweaks(for: context.user)

      assert length(tweaks) == 3
    end
  end
end
