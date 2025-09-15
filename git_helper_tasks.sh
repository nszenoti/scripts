#!/bin/bash

# Make the script executable
# Run this command only for first time in your system (ie before script is ever used)
# chmod +x git_helper_tasks.sh

glogdiff() {
  if [[ -z "$1" ]]; then
    echo "Usage: glogdiff <parent-branch>"
    return 1
  fi
  git log "$1".. --oneline
}