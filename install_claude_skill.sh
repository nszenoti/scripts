#!/bin/bash

# muse-suite install script
# Usage: place this script in the same folder as your .skill files, then run it

set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 Muse Suite Installer"
echo "Installing to: $SKILLS_DIR"
echo ""

# Create skills directory if it doesn't exist
# mkdir -p "$SKILLS_DIR"

# Find all .skill files in the same folder as this script
SKILL_FILES=("$SCRIPT_DIR"/*.skill)

if [ ${#SKILL_FILES[@]} -eq 0 ] || [ ! -f "${SKILL_FILES[0]}" ]; then
  echo "❌ No .skill files found in $SCRIPT_DIR"
  echo "   Place this script in the same folder as your .skill files."
  exit 1
fi

# Unzip each .skill file into the skills directory
for skill_file in "${SKILL_FILES[@]}"; do
  skill_name=$(basename "$skill_file" .skill)
  echo -n "  Installing $skill_name ... "
  unzip -q -o "$skill_file" -d "$SKILLS_DIR"
  echo "✓"
done

echo ""
echo "✅ Done. Skills installed:"
echo ""

# List what's now in the skills directory
for skill_file in "${SKILL_FILES[@]}"; do
  skill_name=$(basename "$skill_file" .skill)
  if [ -d "$SKILLS_DIR/$skill_name" ]; then
    echo "  ~/.claude/skills/$skill_name/"
  fi
done

echo ""
echo "You can safely delete the .skill files — they're no longer needed."