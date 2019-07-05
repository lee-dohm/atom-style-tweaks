workflow "Generate documentation on push" {
  on = "push"
  resolves = ["Publish docs"]
}

workflow "Validate release notes on pull request" {
  on = "pull_request"
  resolves = ["Debug info", "Extract release notes"]
}

workflow "Post release notes on pull request" {
  on = "pull_request"
  resolves = ["Post release notes"]
}

action "Debug info" {
  uses = "actions/bin/debug@master"
}

action "Only on master branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Generate docs" {
  needs = ["Only on master branch"]
  uses = "lee-dohm/generate-elixir-docs@master"
  env = {
    MIX_ENV = "test"
    TAG_VERSION_WITH_HASH = "true"
  }
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

action "Except dependency pull requests" {
  uses = "./.github/actions/not-dependencies"
}

action "Extract release notes" {
  needs = ["Except dependency pull requests"]
  uses = "lee-dohm/extract-release-notes@master"
}

action "Only merged pull requests" {
  uses = "actions/bin/filter@master"
  args = "merged true"
}

action "Post release notes" {
  needs = ["Only merged pull requests", "Extract release notes"]
  uses = "./.github/actions/post-release-notes"
  secrets = ["ATOM_TWEAKS_API_KEY"]
}
