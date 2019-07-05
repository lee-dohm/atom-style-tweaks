FROM ruby:2.6

LABEL "com.github.actions.name"="Not dependencies"
LABEL "com.github.actions.description"="Returns neutral if any label matches 'dependencies'"
LABEL "com.github.actions.icon"="filter"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/lee-dohm/atom-style-tweaks"
LABEL "homepage"="https://github.com/lee-dohm/atom-style-tweaks"
LABEL "maintainer"="Lee Dohm <lee-dohm@github.com>"

COPY ./bin/match-dependencies .
COPY ./entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]
