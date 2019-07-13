defmodule AtomTweaks.Factory do
  @moduledoc """
  Factories for generating fake database records.
  """

  use ExMachina.Ecto, repo: AtomTweaks.Repo

  alias FakerElixir.Avatar
  alias FakerElixir.Helper
  alias FakerElixir.Internet
  alias FakerElixir.Lorem

  alias AtomTweaks.Accounts.Token
  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Logs.Entry
  alias AtomTweaks.Markdown
  alias AtomTweaks.Releases.Note
  alias AtomTweaks.Tweaks.Tweak

  def entry_factory do
    %Entry{
      key: "category.subcategory",
      value: %{}
    }
  end

  @doc """
  Generates realistic-looking `AtomTweaks.Releases.Note` records.
  """
  def note_factory do
    %Note{
      description: %Markdown{text: Lorem.sentences()},
      detail_url: Internet.url(),
      title: Lorem.words(2..4)
    }
  end

  @doc """
  Generates realistic-looking `AtomTweaks.Accounts.Token` records.
  """
  def token_factory do
    %Token{
      description: Lorem.words(2..4),
      scopes: ["release_notes/write"],
      user: insert(:user)
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
      name: Helper.unique!(:user_names, fn -> Internet.user_name() end),
      site_admin: false,
      github_id: Helper.unique!(:user_ids, fn -> Helper.pick(1..10_000) end),
      avatar_url: Avatar.robohash()
    }
  end

  @doc """
  For when you need params for a given record to supply to an API.
  """
  def json_params_for(key, attrs \\ []) do
    key
    |> params_for(attrs)
    |> Jason.encode!()
  end
end
