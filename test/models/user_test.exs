defmodule AtomStyleTweaks.UserTest do
  use AtomStyleTweaks.ModelCase

  alias AtomStyleTweaks.User

  @valid_attrs %{name: "an-admin-user", github_id: 12345, site_admin: true, avatar_url: "https://example.com"}
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
