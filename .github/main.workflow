workflow "Generate documentation on push" {
  on = "push"
  resolves = ["Publish Elixir docs"]
}

# action "Only on master branch" {
#   uses = "actions/bin/filter@master"
#   args = "branch master"
# }

action "Generate docs" {
  needs = ["Only on master branch"]
  uses = "lee-dohm/generate-elixir-docs@master"
}

action "Publish docs" {
  needs = ["Generate docs"]
  uses = "peaceiris/actions-gh-pages@v1.0.1"
  secrets = ["ACTIONS_DEPLOY_KEY"]
  env = {
    PUBLISH_DIR = "./doc"
    PUBLISH_BRANCH = "gh-pages"
  }
}
