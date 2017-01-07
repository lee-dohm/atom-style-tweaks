defmodule AtomStyleTweaks.UserTest do
  use AtomStyleTweaks.ModelCase

  alias AtomStyleTweaks.User

  @test_user %{name: "a-test-user"}
  @valid_attrs %{name: "an-admin-user", site_admin: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "will not allow a duplicate username" do
    Repo.insert!(User.changeset(%User{}, @test_user))
    changeset = User.changeset(%User{}, @test_user)

    refute changeset.valid?
  end
end
