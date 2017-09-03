defmodule AtomStyleTweaks.MarkdownEngine.Test do
  use ExUnit.Case, async: true

  alias AtomStyleTweaks.MarkdownEngine

  test "given nil it renders an empty string" do
    assert MarkdownEngine.render(nil) == ""
  end

  test "given an empty string it renders an empty string" do
    assert MarkdownEngine.render("") == ""
  end

  test "given some text it renders the text into HTML" do
    assert MarkdownEngine.render("test") == "<p>test</p>\n"
  end
end
