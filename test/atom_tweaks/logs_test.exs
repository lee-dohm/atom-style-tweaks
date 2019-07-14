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

  describe "list_entries/1" do
    test "returns 25 entries if no limit is set" do
      entries = insert_list(30, :entry)
      retrieved_entries = Logs.list_entries()

      assert length(retrieved_entries) == 25
      assert Enum.all?(retrieved_entries, fn entry -> entry in entries end)
    end

    test "allows setting the limit" do
      entries = insert_list(5, :entry)
      retrieved_entries = Logs.list_entries(limit: 3)

      assert length(retrieved_entries) == 3
      assert Enum.all?(retrieved_entries, fn entry -> entry in entries end)
    end

    test "allows setting offset" do
      entries = insert_list(5, :entry)
      retrieved_entries = Logs.list_entries(limit: 3)
      more_entries = Logs.list_entries(limit: 3, offset: 3)
      all_entries = retrieved_entries ++ more_entries

      assert length(all_entries) == 5
      assert Enum.all?(all_entries, fn entry -> entry in entries end)
    end
  end

  describe "entries" do
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
