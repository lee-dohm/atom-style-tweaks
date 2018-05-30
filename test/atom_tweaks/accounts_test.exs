defmodule AtomTweaks.AccountsTest do
  use AtomTweaks.DataCase

  import Support.SetupHelpers

  alias AtomTweaks.Accounts

  setup [:insert_tweak]

  test "star a tweak", context do
    {:ok, star} = Accounts.star_tweak(context.user, context.tweak)
    stars = Accounts.list_stars(context.user)

    assert length(stars) == 1
    assert star.user_id == context.user.id
    assert star.tweak_id == context.tweak.id
  end

  test "unstar a tweak", context do
    {:ok, _} = Accounts.star_tweak(context.user, context.tweak)
    {:ok, deleted_star} = Accounts.unstar_tweak(context.user, context.tweak)
    stars = Accounts.list_stars(context.user)

    assert length(stars) == 0
    assert deleted_star.user_id == context.user.id
    assert deleted_star.tweak_id == context.tweak.id
  end
end
