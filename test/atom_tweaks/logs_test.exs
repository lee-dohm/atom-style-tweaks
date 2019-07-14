defmodule AtomTweaks.LogsTest do
  use AtomTweaks.DataCase

  alias AtomTweaks.Logs
  alias AtomTweaks.Logs.Entry

  describe "create_entry/1" do
    test "with valid data creates a entry" do
      params = params_for(:entry)

      assert {:ok, %Entry{} = entry} = Logs.create_entry(params)
      assert entry.key == params.key
      assert entry.value == params.value
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_entry(%{key: nil, value: nil})
    end

    test "returns an error when the key contains whitespace" do
      {:error, changeset} = Logs.create_entry(%{key: "foo bar baz", value: %{}})

      assert "contains whitespace" in errors_on(changeset, :key)
    end

    test "returns an error when the key contains more than one subcategory" do
      {:error, changeset} = Logs.create_entry(%{key: "foo.bar.baz", value: %{}})

      assert "contains more than one subcategory" in errors_on(changeset, :key)
    end
  end

  describe "entries" do
    test "list_entries/0 returns all entries" do
      entry = insert(:entry)

      assert Logs.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = insert(:entry)

      assert Logs.get_entry!(entry.id) == entry
    end

    test "change_entry/1 returns a entry changeset" do
      entry = insert(:entry)

      assert %Ecto.Changeset{} = Logs.change_entry(entry)
    end
  end
end
