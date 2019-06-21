workflow "Generate documentation on push" {
  on = "push"
  resolves = ["Publish docs"]
}

workflow "Validate release notes on pull request" {
  on = "pull_request"
  resolves = ["Debug info", "Validate release notes"]
}

workflow "Post release notes on pull request" {
  on = "pull_request"
  resolves = ["Debug info", "Post release notes"]
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

action "Only merged pull requests" {
  uses = "actions/bin/filter@master"
  args = "merged true"
}

action "Except dependency pull requests" {
  uses = "actions/bin/filter@master"
  args = "not label 'dependencies :gear:'"
}

action "Extract release notes" {
  uses = "lee-dohm/extract-release-notes@master"
}

action "Post release notes" {
  needs = ["Only merged pull requests", "Except dependency pull requests", "Extract release notes"]
  uses = "./.github/post-release-notes"
  secrets = ["ATOM_TWEAKS_API_KEY"]
}

action "Validate release notes" {
  needs = ["Except dependency pull requests", "Extract release notes"]
  uses = "actions/bin/sh@master"
  args = [
    "[ ! -z \"$(cat \"$GITHUB_WORKSPACE/__RELEASE_NOTES.md\")\"]"
  ]
}
