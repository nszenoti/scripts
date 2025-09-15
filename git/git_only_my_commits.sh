#!/bin/zsh
# Usage: ./git_only_my_commits.sh <base-branch>

BASE_BRANCH=$1

if [ -z "$BASE_BRANCH" ]; then
  echo "Usage: $0 <base-branch>"
  exit 1
fi


# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
# or
# CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Show commits in current branch but not in base branch
git log $BASE_BRANCH..$CURRENT_BRANCH --oneline --graph --decorate
