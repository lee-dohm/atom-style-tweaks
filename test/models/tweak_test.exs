defmodule AtomStyleTweaks.TweakTest do
  use AtomStyleTweaks.ModelCase

  alias AtomStyleTweaks.Tweak

  @valid_attrs %{code: "some content", title: "some content", created_by: Ecto.UUID.generate()}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tweak.changeset(%Tweak{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tweak.changeset(%Tweak{}, @invalid_attrs)
    refute changeset.valid?
  end
end
