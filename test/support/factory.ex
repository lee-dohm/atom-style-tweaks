defmodule AtomStyleTweaks.Factory do
  use ExMachina.Ecto, repo: AtomStyleTweaks.Repo

  alias FakerElixir, as: Faker

  alias AtomStyleTweaks.Style
  alias AtomStyleTweaks.User

  def user_factory do
    %User{
      name: Faker.Internet.user_name(),
      site_admin: false,
      github_id: Faker.Helper.pick(1..100),
      avatar_url: Faker.Avatar.robohash()
    }
  end

  def style_factory do
    %Style{
      title: Faker.Lorem.words(2..4),
      code: "atom-text-editor { font-style: normal; }",
      user: build(:user)
    }
  end
end
