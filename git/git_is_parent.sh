#!/bin/bash

# Usage:
# ./git-check-parent.sh <possible-parent> [possible-child]
# Example: ./git-check-parent.sh main
# Example: ./git-check-parent.sh main feature-x

if [ $# -lt 1 ]; then
    echo "Usage: $0 <possible-parent> [possible-child]"
    exit 1
fi

PARENT="$1"
CHILD="${2:-$(git branch --show-current)}"  # Use second argument if provided, otherwise use current branch

if git merge-base --is-ancestor "$PARENT" "$CHILD"; then
    echo "✅ $PARENT is an ancestor of $CHILD"
else
    echo "❌ $PARENT is NOT an ancestor of $CHILD"
fi