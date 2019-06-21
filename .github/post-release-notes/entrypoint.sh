#!/bin/sh

# Exit on failure
set -e

if [ -z "$RELEASE_NOTES_PATH" ]; then
  RELEASE_NOTES_PATH="__RELEASE_NOTES.md"
fi

if [ -z "$ATOM_TWEAKS_API_KEY" ]; then
  echo "Error: ATOM_TWEAKS_API_KEY is a required variable"
  exit 1
fi

file_path="$GITHUB_WORKSPACE/$RELEASE_NOTES_PATH"

if [ ! -e "$file_path" ]; then
  echo "Error: Could not find file $file_path"
  exit 1
fi

./validate-release-notes "$file_path"

title=$(jq .pull_request.title "$GITHUB_EVENT_PATH")
detail_url=$(jq .pull_request.url "$GITHUB_EVENT_PATH")

httpie "authorization:token $ATOM_TWEAKS_API_KEY" "title=$title" "detail_url=$detail_url" \
       "description=@$file_path"
