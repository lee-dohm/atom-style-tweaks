defmodule AtomTweaks.MarkdownTest do
  use ExUnit.Case
  doctest AtomTweaks.Markdown

  import Phoenix.HTML.Safe, only: [to_iodata: 1]

  alias AtomTweaks.Markdown

  describe "Phoenix.HTML.Safe" do
    test "implements the protocol" do
      assert to_iodata(%Markdown{text: "# Foo"}) =~ "<h1>Foo</h1>"
    end
  end
end
