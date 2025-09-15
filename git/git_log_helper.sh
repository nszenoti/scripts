#!/bin/bash

# First time
# chmod +x ~/scripts/git/git_log_helper.sh

# Usage
# ./git-log.sh <type> [n]
# type:
# - a = pretty format,
# - b = oneline graph
# n = number of commits to show (optional)

TYPE="$1"
N="$2"
BRANCH="$(git branch --show-current)"

case "$TYPE" in
    a)
        if [ -z "$N" ]; then
            git log --pretty=format:"%h %ad | %s%d [%an]" --date=short
        else
            git log -n "$N" --pretty=format:"%h %ad | %s%d [%an]" --date=short
        fi
        ;;
    b)
        if [ -z "$N" ]; then
            git log --oneline --graph --decorate --all
        else
            git log -n "$N" --oneline --graph --decorate --all
        fi
        ;;
    c)
        if [ -z "$N" ]; then
            git log --abbrev-commit \
                --pretty=format:"%C(green)%h%C(reset) %s %C(yellow)[%an]%C(reset) %C(cyan)(%ar)%C(reset)"
        else
            git log -n "$N" --abbrev-commit \
                --pretty=format:"%C(green)%h%C(reset) %s %C(yellow)[%an]%C(reset) %C(cyan)(%ar)%C(reset)"
        fi
        ;;
    d)
        git log -g $BRANCH --oneline
        ;;
    *)
        echo "Invalid type. Use:"
        echo "  a = pretty format"
        echo "  b = graph format"
        echo "  c = colorful concise format"
        exit 1
        ;;
esac
