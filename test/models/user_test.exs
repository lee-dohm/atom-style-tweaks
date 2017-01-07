defmodule AtomStyleTweaks.UserTest do
  use AtomStyleTweaks.ModelCase

  alias AtomStyleTweaks.User

  @valid_attrs %{name: "a-site-admin", site_admin: true}
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
