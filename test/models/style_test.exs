defmodule AtomStyleTweaks.StyleTest do
  use AtomStyleTweaks.ModelCase

  alias AtomStyleTweaks.Style

  @valid_attrs %{code: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Style.changeset(%Style{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Style.changeset(%Style{}, @invalid_attrs)
    refute changeset.valid?
  end
end
