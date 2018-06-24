defmodule AtomTweaks.Tweaks.StarTest do
  use AtomTweaks.DataCase

  import Support.SetupHelpers

  alias AtomTweaks.Tweaks.Star

  def build_star(params \\ []) do
    Star.changeset(%Star{}, Enum.into(params, %{}))
  end

  describe "creating a changeset" do
    setup :insert_tweak

    test "with valid attributes", context do
      star = build_star(user_id: context.user.id, tweak_id: context.tweak.id)

      assert star.valid?
    end

    test "with a nil user id", context do
      star = build_star(user_id: nil, tweak_id: context.tweak.id)

      refute star.valid?
      assert error_on?(star, :user_id)
    end

    test "with a nil tweak id", context do
      star = build_star(user_id: context.user.id, tweak_id: nil)

      refute star.valid?
      assert error_on?(star, :tweak_id)
    end
  end
end
