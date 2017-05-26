# AtomStyleTweaks

[![Travis](https://img.shields.io/travis/lee-dohm/atom-style-tweaks.svg)]()
[![Coveralls](https://img.shields.io/coveralls/lee-dohm/atom-style-tweaks.svg)]()

Website for collecting style tweaks for Atom.

## Common Tasks

This project follows the [GitHub "scripts to rule them all" pattern](http://githubengineering.com/scripts-to-rule-them-all/). The contents of the `scripts` directory are scripts that cover all common tasks:

* `script/setup` &mdash; Performs first-time setup
* `script/update` &mdash; Performs periodic updating
* `script/test` &mdash; Runs automated tests
* `script/server` &mdash; Launches the web server
* `script/console` &mdash; Opens the development console
* `script/db-console` &mdash; Opens the database console for the development database
* `script/docs` &mdash; Generates developer documentation
* `script/publish` &mdash; Publishes the current version to Heroku

Other scripts that are available but not intended to be used directly by developers:

* `script/bootstrap` &mdash; Used to do a one-time install of all prerequisites for a development machine
* `script/cibuild` &mdash; Used to run automated tests in the CI environment

## Copyright

Copyright &copy; 2017 by [Lee Dohm](http://www.lee-dohm.com). See [LICENSE](https://raw.githubusercontent.com/lee-dohm/atom-style-tweaks/master/LICENSE.md) for details.
