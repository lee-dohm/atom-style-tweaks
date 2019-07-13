defmodule AtomTweaks.LogsTest do
  use AtomTweaks.DataCase

  alias AtomTweaks.Logs

  describe "entries" do
    alias AtomTweaks.Logs.Entry

    @valid_attrs %{key: "some key", value: %{}}
    @update_attrs %{key: "some updated key", value: %{}}
    @invalid_attrs %{key: nil, value: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Logs.create_entry()

      entry
    end

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Logs.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Logs.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Logs.create_entry(@valid_attrs)
      assert entry.key == "some key"
      assert entry.value == %{}
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Logs.update_entry(entry, @update_attrs)
      assert entry.key == "some updated key"
      assert entry.value == %{}
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Logs.update_entry(entry, @invalid_attrs)
      assert entry == Logs.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Logs.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Logs.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Logs.change_entry(entry)
    end
  end
end
