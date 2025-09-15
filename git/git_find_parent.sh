#!/bin/bash

# First time execute this script (register permission)
# chmod +x ~/scripts/git/git-find-parent.sh


# Example 1
# git-find-parent F1 main develop origin/main

# Example 2
# git-find-parent F1

# Get current branch
BR=$(git branch --show-current)

# Usage check
# if [ -z "$1" ]; then
#     echo "Usage: git-find-parent <branch> [branch1 branch2 ...]"
#     exit 1
# fi

# BR="$1"
# shift  # Remove first argument so $@ is candidate branches

# Determine candidate branches
if [ $# -gt 0 ]; then
    # Use provided list
    CANDIDATES=("$@")
else
    # Use all local + remote branches except target
    CANDIDATES=($(git for-each-ref --format="%(refname:short)" refs/heads refs/remotes | grep -v "^$BR$" | grep -v "^origin/$BR$"))
fi

# Array to hold ancestor branches
PARENTS=()

# Loop through candidate branches
for B in "${CANDIDATES[@]}"; do
    if git merge-base --is-ancestor "$B" "$BR"; then
        PARENTS+=("$B")
    fi
done

# Pick the closest ancestor (most recent commit)
if [ ${#PARENTS[@]} -eq 0 ]; then
    echo "No parent branch found"
else
    LATEST_PARENT=""
    LATEST_COMMIT=0
    for P in "${PARENTS[@]}"; do
        HASH=$(git rev-parse "$P")
        COMMIT_TIME=$(git show -s --format=%ct "$HASH")
        if [ $COMMIT_TIME -gt $LATEST_COMMIT ]; then
            LATEST_COMMIT=$COMMIT_TIME
            LATEST_PARENT=$P
        fi
    done
    echo "Likely parent branch: $LATEST_PARENT"
fi
