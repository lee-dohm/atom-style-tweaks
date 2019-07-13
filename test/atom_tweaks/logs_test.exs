defmodule AtomTweaks.LogsTest do
  use AtomTweaks.DataCase

  alias AtomTweaks.Logs

  describe "entries" do
    alias AtomTweaks.Logs.Entry

    test "list_entries/0 returns all entries" do
      entry = insert(:entry)

      assert Logs.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = insert(:entry)

      assert Logs.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      params = params_for(:entry)

      assert {:ok, %Entry{} = entry} = Logs.create_entry(params)
      assert entry.key == params.key
      assert entry.value == params.value
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_entry(%{key: nil, value: nil})
    end

    test "change_entry/1 returns a entry changeset" do
      entry = insert(:entry)

      assert %Ecto.Changeset{} = Logs.change_entry(entry)
    end
  end
end
