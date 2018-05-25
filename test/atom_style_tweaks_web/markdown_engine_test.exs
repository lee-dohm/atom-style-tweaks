defmodule AtomStyleTweaksWeb.MarkdownEngineTest do
  use ExUnit.Case

  alias AtomStyleTweaksWeb.MarkdownEngine

  def bad_func(_, _) do
    raise "bummer"
  end

  def github(match, _) do
    if match =~ ~r/@github/ || match =~ ~r/@both/ do
      "github-replacement"
    end
  end

  def tweaks(match, _) do
    if match =~ ~r/@tweaks/ || match =~ ~r/@both/ do
      "tweaks-replacement"
    end
  end

  describe "render" do
    test "returns an empty string when given nil", _context do
      assert MarkdownEngine.render(nil) == ""
    end

    test "returns an empty string when given an empty string", _context do
      assert MarkdownEngine.render("") == ""
    end

    test "renders text into an HTML fragment", _context do
      assert MarkdownEngine.render("test") == "<p>test</p>\n"
    end
  end

  describe "replace mention" do
    setup do
      {
        :ok,
        both_mention: "This text has a @both-mention in it",
        funcs: [&tweaks/2, &github/2],
        github_mention: "This text has a @github-mention in it",
        no_mentions: "This text has no mentions in it",
        tweaks_mention: "This text has a @tweaks-mention in it"
      }
    end

    test "returns nil unchanged", context do
      assert MarkdownEngine.replace_mention(nil, context.funcs) == nil
    end

    test "returns an empty string unchanged", context do
      assert MarkdownEngine.replace_mention("", context.funcs) == ""
    end

    test "returns text without mentions unchanged", context do
      assert MarkdownEngine.replace_mention(context.no_mentions, context.funcs) == context.no_mentions
    end

    test "replaces mentions that are handled by a function", context do
      assert MarkdownEngine.replace_mention(context.tweaks_mention, context.funcs) == "This text has a tweaks-replacement in it"
    end

    test "replaces mentions that are handled by any function in the list", context do
      assert MarkdownEngine.replace_mention(context.github_mention, context.funcs) == "This text has a github-replacement in it"
    end

    test "replaces mentions with the earliest matching function", context do
      assert MarkdownEngine.replace_mention(context.both_mention, context.funcs) == "This text has a tweaks-replacement in it"
    end

    test "does not call later functions if an earlier one matches", context do
      assert MarkdownEngine.replace_mention(context.tweaks_mention, [&tweaks/2, &bad_func/2]) == "This text has a tweaks-replacement in it"
    end
  end
end
