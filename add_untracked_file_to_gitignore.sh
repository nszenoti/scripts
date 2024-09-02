#!/bin/bash

# Make the script executable
# Run this command only for first time in your system (ie before script is ever used)
# chmod +x add_to_gitignore.sh

if [ -z "$1" ]; then
  echo "Usage: $0 <ProjName>"
  exit 1
fi

PROJ_NAME=$1

# Add a comment to .gitignore
echo -e "\n\n# Auto-added by $0 script\n" >> .gitignore

# List untracked files, & remove the project name prefix
git ls-files --others --exclude-standard --full-name | sed "s|^$PROJ_NAME/||" >> .gitignore
