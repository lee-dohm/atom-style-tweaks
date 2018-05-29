defmodule AtomTweaks.Factory do
  use ExMachina.Ecto, repo: AtomTweaks.Repo

  alias FakerElixir, as: Faker

  alias AtomTweaks.Markdown

  alias AtomTweaks.Tweak
  alias AtomTweaks.User

  def user_factory do
    %User{
      name: Faker.Internet.user_name(),
      site_admin: false,
      github_id: Faker.Helper.pick(1..10_000),
      avatar_url: Faker.Avatar.robohash()
    }
  end

  def tweak_factory do
    %Tweak{
      title: Faker.Lorem.words(2..4),
      code: "atom-text-editor { font-style: normal; }",
      description: %Markdown{text: Faker.Lorem.sentences()},
      type: "style",
      user: build(:user)
    }
  end
end
