workflow "Generate documentation on push" {
  on = "push"
  resolves = ["publish-docs"]
}

action "publish-elixir-docs" {
  needs = "only-master"
  uses = "lee-dohm/publish-elixir-docs@master"
}
