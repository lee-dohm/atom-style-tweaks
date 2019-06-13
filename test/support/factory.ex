defmodule AtomTweaks.Factory do
  @moduledoc """
  Factories for generating fake database records.
  """

  use ExMachina.Ecto, repo: AtomTweaks.Repo

  alias FakerElixir.Avatar
  alias FakerElixir.Helper
  alias FakerElixir.Internet
  alias FakerElixir.Lorem

  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Markdown
  alias AtomTweaks.Releases.Note
  alias AtomTweaks.Tweaks.Tweak

  def note_factory do
    %Note{
      description: %Markdown{text: Lorem.sentences()},
      detail_url: Internet.url(),
      title: Lorem.words(2..4)
    }
  end

  @doc """
  Generates realistic-looking `AtomTweaks.Tweaks.Tweak` records.
  """
  def tweak_factory do
    %Tweak{
      title: Lorem.words(2..4),
      code: "atom-text-editor { font-style: normal; }",
      description: %Markdown{text: Lorem.sentences()},
      type: Helper.pick(["init", "style"]),
      user: build(:user)
    }
  end

  @doc """
  Generates realistic-looking `AtomTweaks.Accounts.User` records.
  """
  def user_factory do
    %User{
      name: Internet.user_name(),
      site_admin: false,
      github_id: Helper.pick(1..10_000),
      avatar_url: Avatar.robohash()
    }
  end
end
