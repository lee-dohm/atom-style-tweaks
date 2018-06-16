defmodule AtomTweaks.Factory do
  @moduledoc """
  Factories for generating fake database records.
  """
  use ExMachina.Ecto, repo: AtomTweaks.Repo

  alias FakerElixir, as: Faker

  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Markdown
  alias AtomTweaks.Tweaks.Tweak

  def tweak_factory do
    %Tweak{
      title: Faker.Lorem.words(2..4),
      code: "atom-text-editor { font-style: normal; }",
      description: %Markdown{text: Faker.Lorem.sentences()},
      type: "style",
      user: build(:user)
    }
  end

  def user_factory do
    %User{
      name: Faker.Internet.user_name(),
      site_admin: false,
      github_id: Faker.Helper.pick(1..10_000),
      avatar_url: Faker.Avatar.robohash()
    }
  end
end
