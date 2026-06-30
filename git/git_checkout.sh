#!/bin/zsh
# Usage: ./checkout-new.sh <new-branch-name>

NEW_BRANCH=$1

if [ -z "$NEW_BRANCH" ]; then
  echo "Usage: $0 <new-branch-name>"
  exit 1
fi

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "You have uncommitted changes."
  read "stash_choice?Do you want to stash them before switching branch? (y/n) "
  if [[ "$stash_choice" =~ ^[Yy]$ ]]; then
    read "stash_msg?Enter stash message: "
    git stash push -m "$stash_msg"
    echo "Changes stashed."
  else
    echo "Proceeding without stashing. Your changes will stay in current branch."
  fi
fi

# Checkout new branch
git checkout "$NEW_BRANCH"
echo "Switched to branch '$NEW_BRANCH'"
