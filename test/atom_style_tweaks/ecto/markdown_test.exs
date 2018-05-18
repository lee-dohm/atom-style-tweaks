defmodule AtomStyleTweaks.Ecto.MarkdownTest do
  use ExUnit.Case, async: true

  alias AtomStyleTweaks.Ecto.Markdown

  describe "casting" do
    test "a binary returns a Markdown struct" do
      {:ok, %AtomStyleTweaks.Markdown{}} = Markdown.cast("foo")
    end

    test "a Markdown struct returns the struct" do
      {:ok, %AtomStyleTweaks.Markdown{} = markdown} = Markdown.cast(%AtomStyleTweaks.Markdown{text: "test"})

      assert markdown.text == "test"
      assert is_nil(markdown.html)
    end

    test "anything else returns an error" do
      assert :error == Markdown.cast(7)
    end
  end

  describe "loading" do
    test "a binary returns a rendered Markdown struct" do
      {:ok, %AtomStyleTweaks.Markdown{} = markdown} = Markdown.load("test")

      assert markdown.text == "test"
      assert markdown.html == "<p>test</p>\n"
    end

    test "anything else returns an error" do
      assert :error == Markdown.load(7)
    end
  end

  describe "dumping" do
    test "a Markdown struct returns the text value" do
      {:ok, text} = Markdown.dump(%AtomStyleTweaks.Markdown{text: "test"})

      assert text == "test"
    end

    test "a binary returns the binary" do
      {:ok, text} = Markdown.dump("test")

      assert text == "test"
    end

    test "anything else returns an error" do
      assert :error == Markdown.dump(7)
    end
  end
end
