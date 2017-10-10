defmodule AtomStyleTweaksWeb.MarkdownEngine.Spec do
  use ESpec.Phoenix, async: true

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
    it "returns an empty string when given nil" do
      expect(MarkdownEngine.render(nil)).to eq("")
    end

    it "returns an empty string when given an empty string" do
      expect(MarkdownEngine.render("")).to eq("")
    end

    it "renders text into an HTML fragment" do
      expect(MarkdownEngine.render("test")).to eq("<p>test</p>\n")
    end
  end

  describe "replace_mention" do
    let :both_mention, do: "This text has a @both-mention in it"
    let :funcs, do: [&tweaks/2, &github/2]
    let :github_mention, do: "This text has a @github-mention in it"
    let :no_mentions, do: "This text has no mentions"
    let :tweaks_mention, do: "This text has a @tweaks-mention in it"

    it "returns nil unchanged" do
      expect(MarkdownEngine.replace_mention(nil, funcs())).to eq(nil)
    end

    it "returns the empty string unchanged" do
      expect(MarkdownEngine.replace_mention("", funcs())).to eq("")
    end

    it "returns text without mentions unchanged" do
      expect(MarkdownEngine.replace_mention(no_mentions(), funcs())).to eq(no_mentions())
    end

    it "replaces mentions that are handled by a function" do
      expect(MarkdownEngine.replace_mention(tweaks_mention(), funcs())).to eq("This text has a tweaks-replacement in it")
    end

    it "replaces mentions that are handled by any function in the list" do
      expect(MarkdownEngine.replace_mention(github_mention(), funcs())).to eq("This text has a github-replacement in it")
    end

    it "replaces mentions with the earliest matching function" do
      expect(MarkdownEngine.replace_mention(both_mention(), funcs())).to eq("This text has a tweaks-replacement in it")
    end

    it "does not call later functions if an earlier one matches" do
      expect(MarkdownEngine.replace_mention(tweaks_mention(), [&tweaks/2, &bad_func/2])).to eq("This text has a tweaks-replacement in it")
    end
  end
end
