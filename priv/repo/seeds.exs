# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AtomStyleTweaks.Repo.insert!(%AtomStyleTweaks.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AtomStyleTweaks.Repo
alias AtomStyleTweaks.Style
alias AtomStyleTweaks.User

users = [
  %{name: "lee-dohm", github_id: 1038121, avatar_url: "https://avatars.githubusercontent.com/u/1038121?v=3", site_admin: true},
  %{name: "hubot", github_id: 480938, avatar_url: "https://avatars3.githubusercontent.com/u/480938?v=3&s=400", site_admin: false}
]

Enum.each(users, fn(user) ->
  unless Repo.get_by(User, github_id: user.github_id) do
    Repo.insert!(User.changeset(%User{}, user))
  end
end)

tweaks = [
  %{title: "Test tweak", code: "atom-text-editor { font-style: normal; }"}
]

user = Repo.get_by!(User, name: "lee-dohm")
Enum.each(tweaks, fn(tweak) ->
  unless Repo.get_by(Style, title: tweak.title) do
    tweak = Map.put_new(tweak, :created_by, user.id)
    Repo.insert!(Style.changeset(%Style{}, tweak))
  end
end)
