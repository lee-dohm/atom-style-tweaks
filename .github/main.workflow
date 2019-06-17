workflow "Generate documentation on push" {
  on = "push"
  resolves = ["publish-elixir-docs"]
}

action "publish-elixir-docs" {
  uses = "lee-dohm/publish-elixir-docs@master"
}
