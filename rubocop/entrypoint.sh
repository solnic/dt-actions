#!/bin/sh -l

if [[ $GITHUB_EVENT_NAME == "pull_request" ]]; then
  git fetch origin $GITHUB_BASE_REF
  git fetch origin $GITHUB_HEAD_REF

  changed_files=$(ah ws cf --range "origin/$GITHUB_BASE_REF...origin/$GITHUB_HEAD_REF" --types ruby)
else
  git pull --depth=2

  changed_files=$(ah ws cf --range "$GITHUB_SHA~1" --types ruby)
fi

echo "::group::Changed/Added files"
echo "$changed_files"
echo "::endgroup::"

if [[ -z "$changed_files" ]]; then
  echo "No changes found, skipping checks"
else
  ah m rubocop -- --format github $changed_files
fi
