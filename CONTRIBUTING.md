# Contributing

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

Our [README](README.md) describes the project, its purpose, and is necessary reading for contributors.

This project adheres to a [code of conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

Contributions to this project are made under the [MIT License](LICENSE.md).

## Help wanted

Browse [open issues](https://github.com/lee-dohm/atom-style-tweaks/issues) to see current requests.

[Open an issue](https://github.com/lee-dohm/atom-style-tweaks/issues/new) to tell us about a bug. You may also open a pull request to propose specific changes, but it's always OK to start with an issue.

[Help with translating](#translating) the website into other languages.

## Setting up the development environment

You'll need to:

1. Install [PostgreSQL][postgres-download] and start it
1. Create [a GitHub OAuth app][oauth-app] - set the callback URL to `http://localhost:4000/auth/callback`
1. Copy `.env.example` to `.env` and set the `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` values to the ones obtained from the application in the previous step
1. Run `script/setup`

[oauth-app]: https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/
[postgres-download]: https://www.postgresql.org/download/

## Common Tasks

This project follows the [GitHub "scripts to rule them all" pattern](http://githubengineering.com/scripts-to-rule-them-all/). The contents of the `scripts` directory are scripts that cover all common tasks:

* `script/setup` &mdash; Performs first-time setup
* `script/update` &mdash; Performs periodic updating
* `script/test` &mdash; Runs automated tests, format and linter checks
* `script/server` &mdash; Launches the local development web server
* `script/console` &mdash; Opens the development console
* `script/db-console` &mdash; Opens the database console for the development database
* `script/docs` &mdash; Generates developer documentation
* `script/translate` &mdash; Extract and merge new message strings in `priv/gettext`

See the documentation at the top of each script for more information about what each one does and is capable of.

Other scripts that are available but not intended to be used directly by developers:

* `script/bootstrap` &mdash; Used to do a one-time install of all prerequisites for a development machine
* `script/cibuild` &mdash; Used to run automated tests in the CI environment

## Writing Tests

* Controller specs should verify:
    * HTTP Status
    * Redirects
    * Assigns
    * Session values
* Controller specs **should not** verify content
* View specs should verify that given the expected assigns, the right content is displayed

## Translations

If you would like to help with translating Atom Tweaks into languages other than US English, you can:

1. Create a new directory under `priv/gettext` that is the [name of the locale](https://en.wikipedia.org/wiki/Locale_(computer_software)) for which you will be providing a translation (for example, to provide a translation for Brazilian Portuguese, it would be `priv/gettext/pt_BR`)
1. Run the `script/translate` script to extract and merge the latest version of the strings
1. Add your translations to the `.po` files under your new directory
1. Submit a PR with your changes

## Resources

- [Contributing to Open Source on GitHub](https://guides.github.com/activities/contributing-to-open-source/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
