defmodule Mix.Tasks.PseudolocTest do
  use ExUnit.Case
  doctest Mix.Tasks.Pseudoloc

  alias Mix.Tasks.Pseudoloc

  describe "get_ranges/1" do
    test "returns a single range consisting of the entire string when there is no interpolation" do
      assert Pseudoloc.get_ranges("foo") == [{0, 3}]
    end

    test "returns empty list on empty string" do
      assert Pseudoloc.get_ranges("") == []
    end

    test "returns the range before a single interpolation and the range after" do
      assert Pseudoloc.get_ranges("foo%{bar}baz") == [{0, 3}, {9, 3}]
    end

    test "returns the range after an interpolation that starts a string" do
      assert Pseudoloc.get_ranges("%{bar}baz") == [{6, 3}]
    end

    test "returns the range before an interpolation that ends a string" do
      assert Pseudoloc.get_ranges("foo%{bar}") == [{0, 3}]
    end

    test "returns the range before, between, and after interpolations" do
      assert Pseudoloc.get_ranges("foo%{bar}baz%{quux}quuux") == [{0, 3}, {9, 3}, {19, 5}]
    end
  end

  describe "localize_grapheme/2" do
    test "returns the grapheme if there are no applicable alternatives" do
      assert Pseudoloc.localize_grapheme("a", %{}) == "a"
    end

    test "returns a random alternative if there are some" do
      assert Pseudoloc.localize_grapheme("a", %{"a" => ["1", "2", "3"]}) in ["1", "2", "3"]
    end
  end
end
