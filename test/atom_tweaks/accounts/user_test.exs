defmodule AtomTweaks.Accounts.UserTest do
  use AtomTweaks.DataCase

  alias AtomTweaks.Accounts.User

  def build_user(params \\ []) do
    User.changeset(%User{}, params_for(:user, params))
  end

  describe "creating a changeset" do
    test "with valid attributes", _context do
      user = build_user()

      assert user.valid?
    end

    test "with an empty name", _context do
      user = build_user(name: "")

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :name)
    end

    test "with a nil name", _context do
      user = build_user(name: nil)

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :name)
    end

    test "with a name that is not a string", _context do
      user = build_user(name: 42)

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :name)
    end

    test "with a nil github_id", _context do
      user = build_user(github_id: nil)

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :github_id)
    end

    test "with a github_id that is not a number", _context do
      user = build_user(github_id: "foo")

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :github_id)
    end

    test "with an empty avatar_url", _context do
      user = build_user(avatar_url: "")

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :avatar_url)
    end

    test "with a nil avatar_url", _context do
      user = build_user(avatar_url: nil)

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :avatar_url)
    end

    test "with an avatar_url that is not a string", _context do
      user = build_user(avatar_url: 42)

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :avatar_url)
    end

    test "with an avatar_url that is not a URL", _context do
      user = build_user(avatar_url: "foo")

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :avatar_url)
    end

    test "with a site_admin value that is not boolean", _context do
      user = build_user(site_admin: 42)

      refute user.valid?
      assert length(user.errors) == 1
      assert has_error_on?(user, :site_admin)
    end
  end

  describe "exists?" do
    test "returns true when the record exists", _context do
      user = insert(:user)

      assert User.exists?(user.name)
    end

    test "returns false when the record does not exist", _context do
      user = build(:user)

      refute User.exists?(user.name)
    end
  end
end
