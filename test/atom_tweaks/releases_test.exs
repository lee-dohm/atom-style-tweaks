defmodule AtomTweaks.ReleasesTest do
  use AtomTweaks.DataCase

  alias AtomTweaks.Markdown
  alias AtomTweaks.Releases

  describe "notes" do
    alias AtomTweaks.Releases.Note

    @valid_attrs params_for(:note)
    @invalid_attrs params_for(:note, description: "", detail_url: "", title: "")

    def render_md(note = %Note{}) do
      description = %Markdown{note.description | html: Markdown.to_html(note.description)}

      %Note{note | description: description}
    end

    test "list_notes/0 returns all notes" do
      note = insert(:note)

      assert Releases.list_notes() == [render_md(note)]
    end

    test "get_note!/1 returns the note with given id" do
      note = insert(:note)

      assert Releases.get_note!(note.id) == render_md(note)
    end

    test "create_note/1 with valid data creates a note" do
      params = params_for(:note)
      assert {:ok, %Note{} = note} = Releases.create_note(params)

      assert note.description == params.description
      assert note.detail_url == params.detail_url
      assert note.title == params.title
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Releases.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = insert(:note)
      params = @valid_attrs

      assert {:ok, %Note{} = updated_note} = Releases.update_note(note, params)
      assert updated_note.description.text == params.description.text
      assert updated_note.detail_url == params.detail_url
      assert updated_note.title == params.title
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = insert(:note)

      assert {:error, %Ecto.Changeset{}} = Releases.update_note(note, @invalid_attrs)
      assert render_md(note) == Releases.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = insert(:note)
      assert {:ok, %Note{}} = Releases.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Releases.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = insert(:note)

      assert %Ecto.Changeset{} = Releases.change_note(note)
    end
  end
end
