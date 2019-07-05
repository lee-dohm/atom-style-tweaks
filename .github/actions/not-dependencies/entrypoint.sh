#!/bin/sh

# Exit on failure
set -e

if [ -z "$GITHUB_EVENT_PATH" ]; then
  echo "Error: GITHUB_EVENT_PATH is a required variable"
  exit 1
fi

/match-dependencies
