defmodule AtomStyleTweaks.TweakTest do
  use AtomStyleTweaks.ModelCase

  alias AtomStyleTweaks.Tweak

  @valid_attrs %{code: "some content", title: "some content", type: "style", created_by: Ecto.UUID.generate()}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tweak.changeset(%Tweak{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tweak.changeset(%Tweak{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "does not allow an undefined type" do
    changeset = Tweak.changeset(%Tweak{}, %{@valid_attrs | type: "foo"})

    refute changeset.valid?
  end

  test "allows init tweak type" do
    changeset = Tweak.changeset(%Tweak{}, %{@valid_attrs | type: "init"})

    assert changeset.valid?
  end

  test "does not allow atom version of type name" do
    changeset = Tweak.changeset(%Tweak{}, %{@valid_attrs | type: :style})

    refute changeset.valid?
  end
end
