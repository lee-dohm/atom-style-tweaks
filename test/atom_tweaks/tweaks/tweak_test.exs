defmodule AtomTweaks.Tweaks.TweakTest do
  use AtomTweaks.DataCase

  alias AtomTweaks.Tweaks.Tweak

  def build_tweak(user, params \\ []) do
    Tweak.changeset(%Tweak{}, params_for(:tweak, [user: user] ++ params))
  end

  describe "creating a changeset" do
    setup [:insert_user]

    test "with valid attributes", context do
      tweak = build_tweak(context.user)

      assert tweak.valid?
    end

    test "with an empty title", context do
      tweak = build_tweak(context.user, title: "")

      refute tweak.valid?
      assert length(tweak.errors) == 1
      assert has_error_on?(tweak, :title)
    end

    test "with a nil title", context do
      tweak = build_tweak(context.user, title: nil)

      refute tweak.valid?
      assert length(tweak.errors) == 1
      assert has_error_on?(tweak, :title)
    end

    test "with empty code", context do
      tweak = build_tweak(context.user, code: "")

      refute tweak.valid?
      assert length(tweak.errors) == 1
      assert has_error_on?(tweak, :code)
    end

    test "with nil code", context do
      tweak = build_tweak(context.user, code: nil)

      refute tweak.valid?
      assert length(tweak.errors) == 1
      assert has_error_on?(tweak, :code)
    end

    test "with an invalid tweak type", context do
      tweak = build_tweak(context.user, type: "foo")

      refute tweak.valid?
      assert length(tweak.errors) == 1
      assert has_error_on?(tweak, :type)
    end

    test "with an empty description", context do
      tweak = build_tweak(context.user, description: "")

      assert tweak.valid?
    end

    test "with a nil description", context do
      tweak = build_tweak(context.user, description: nil)

      assert tweak.valid?
    end

    test "with an invalid user", _context do
      tweak = build_tweak(build(:user))

      refute tweak.valid?
      assert length(tweak.errors) == 1
      assert has_error_on?(tweak, :created_by)
    end

    test "with a nil user", _context do
      tweak = build_tweak(nil)

      refute tweak.valid?
      assert length(tweak.errors) == 1
      assert has_error_on?(tweak, :created_by)
    end
  end
end
