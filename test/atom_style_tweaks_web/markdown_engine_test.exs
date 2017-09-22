defmodule AtomStyleTweaks.MarkdownEngine.Test do
  use ExUnit.Case, async: true

  alias AtomStyleTweaksWeb.MarkdownEngine

  setup do
    github = fn match, _ ->
      if match =~ ~r/@github/ || match =~ ~r/@both/ do
        "github-replacement"
      end
    end

    tweaks = fn match, _ ->
      if match =~ ~r/@tweaks/ || match =~ ~r/@both/ do
        "tweaks-replacement"
      end
    end

    [funcs: [tweaks, github], tweaks: tweaks]
  end

  test "when render is given nil it renders an empty string" do
    assert MarkdownEngine.render(nil) == ""
  end

  test "when render is given an empty string it renders an empty string" do
    assert MarkdownEngine.render("") == ""
  end

  test "when render is given some text it renders the text into HTML" do
    assert MarkdownEngine.render("test") == "<p>test</p>\n"
  end

  test "when replace_mention is given nil it returns nil", context do
    assert MarkdownEngine.replace_mention(nil, context[:funcs]) == nil
  end

  test "when replace_mention is given an empty string it returns an empty string", context do
    assert MarkdownEngine.replace_mention("", context[:funcs]) == ""
  end

  test "when replace_mention is given text with no mentions, it returns the text unchanged", context do
    assert MarkdownEngine.replace_mention("This text has no mentions", context[:funcs]) == "This text has no mentions"
  end

  test "when replace_mention is given text with a mention that is handled by a function, the mention is replaced", context do
    assert MarkdownEngine.replace_mention("This text has a @tweaks-mention in it", context[:funcs]) == "This text has a tweaks-replacement in it"
  end

  test "when replace_mention is given text with a mention that is handled by any function, the mention is replaced", context do
    assert MarkdownEngine.replace_mention("This text has a @github-mention in it", context[:funcs]) == "This text has a github-replacement in it"
  end

  test "when replace_mention is given text with a mention that is handled by multiple functions, the mention is replaced by the earliest one", context do
    assert MarkdownEngine.replace_mention("This text has a @both-mention in it", context[:funcs]) == "This text has a tweaks-replacement in it"
  end

  test "when replace_mention is given text with a mention, that not all functions are called if an earlier one succeeds", context do
    assert MarkdownEngine.replace_mention("This text has a @tweaks-mention in it", [context[:tweaks], fn(_, _) -> raise "bummer" end]) == "This text has a tweaks-replacement in it"
  end
end
