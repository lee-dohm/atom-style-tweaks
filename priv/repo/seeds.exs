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
alias AtomStyleTweaks.User

Repo.insert!(%User{}, %{name: "lee-dohm", github_id: 1038121, avatar_url: "https://avatars.githubusercontent.com/u/1038121?v=3", site_admin: true})
Repo.insert!(%User{}, %{name: "hubot", github_id: 480938, avatar_url: "https://avatars3.githubusercontent.com/u/480938?v=3&s=400", site_admin: false})
