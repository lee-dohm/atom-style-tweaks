defmodule AtomStyleTweaks.UserTest do
  use AtomStyleTweaks.ModelCase

  alias AtomStyleTweaks.User

  @valid_attrs %{name: "an-admin-user", site_admin: true, avatar_url: "https://avatars3.githubusercontent.com/u/1038121?v=3&s=460"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
