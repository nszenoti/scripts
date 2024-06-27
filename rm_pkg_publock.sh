#!/bin/bash

# script to remove particular pkg from pubspec.lock file

# usage >> `rm_pkg_publock.sh example_package``

# NOTE: Run below command first time to grant permission to this script to run from anywhere
# chmod +x ~/scripts/rm_pkg_publock.sh


# Check if package name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <package_name>"
  exit 1
fi

PACKAGE_NAME=$1
LOCK_FILE="pubspec.lock"

# Check if the pubspec.lock file exists
if [ ! -f "$LOCK_FILE" ]; then
  echo "pubspec.lock file not found!"
  exit 1
fi

# Remove the package block from pubspec.lock
awk -v package="$PACKAGE_NAME" '
  BEGIN { in_block=0; }
  /^  [^ ]/ { in_block=0; }
  $0 ~ "  "package":" { in_block=1; next; }
  !in_block { print; }
' "$LOCK_FILE" > "$LOCK_FILE.tmp" && mv "$LOCK_FILE.tmp" "$LOCK_FILE"

echo "Package '$PACKAGE_NAME' removed from pubspec.lock."
