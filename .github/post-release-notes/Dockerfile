FROM elixir:1.8-alpine

LABEL "com.github.actions.name"="Post release notes"
LABEL "com.github.actions.description"="Posts release notes to the Atom Tweaks API"
LABEL "com.github.actions.icon"="upload"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/lee-dohm/post-release-notes"
LABEL "homepage"="https://github.com/lee-dohm/post-release-notes"
LABEL "maintainer"="Lee Dohm <lee-dohm@github.com>"

RUN set -e \
    && apk update \
    && apk add jq \
    && apk add httpie

COPY ./bin/validate-release-notes .
COPY ./entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]
