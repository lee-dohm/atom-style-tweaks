workflow "Generate documentation on push" {
  on = "push"
  resolves = ["Publish Elixir docs"]
}

action "Only on master branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Publish Elixir docs" {
  needs = "Only on master branch"
  uses = "lee-dohm/publish-elixir-docs@master"
  secrets = ["GITHUB_TOKEN"]
}
