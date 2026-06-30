#!/bin/zsh
# Usage: ./checkout-origin.sh <branch-name>


BRANCH=$1

if [ -z "$BRANCH" ]; then
  echo "Usage: $0 <branch-name>"
  exit 1
fi

# Check if branch exists locally
if git show-ref --verify --quiet refs/heads/$BRANCH; then
  git checkout $BRANCH
else
  # Fetch from origin and create local tracking branch
  git fetch origin $BRANCH
  git checkout -b $BRANCH origin/$BRANCH
fi
