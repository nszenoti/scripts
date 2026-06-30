#!/bin/bash

# # Enable alias expansion in script
# shopt -s expand_aliases
# source ~/.zshrc

# FIrst TIme
# Make Script Executable
# chmod +x hc_fc_sync.sh

# Generic Flutter Project Sync Script
# Usage: flutter-sync.sh <source_dir> <target_dir>
#   source_dir: Directory containing the Flutter project
#   target_dir: Destination directory (project will be copied here)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse arguments
SOURCE_DIR="$1"
TARGET_DIR="$2"

# Validate arguments
if [ -z "$SOURCE_DIR" ] || [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    echo "Usage: $0 <source_dir> <target_dir>"
    echo "  source_dir: Directory containing the Flutter project ie HyperConnect"
    echo "  target_dir: Destination directory ie flutter-components/package_hyperconnect"
    exit 1
fi

# Validate source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: Source directory does not exist: $SOURCE_DIR${NC}"
    exit 1
fi

# Validate target directory exists
TARGET_PARENT=$(dirname "$TARGET_DIR")
if [ ! -d "$TARGET_PARENT" ]; then
    echo -e "${RED}Error: Target parent directory does not exist: $TARGET_PARENT${NC}"
    exit 1
fi

# Get folder name from source directory
FOLDER_NAME=$(basename "$SOURCE_DIR")

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}Flutter Project Sync${NC}"
echo -e "${YELLOW}========================================${NC}"
echo -e "Source: $SOURCE_DIR"
echo -e "Target: $TARGET_DIR"
echo ""

# Step 1: Navigate to source directory
echo -e "${YELLOW}Step 1: Navigating to source directory...${NC}"
cd "$SOURCE_DIR" || {
    echo -e "${RED}Error: Failed to navigate to source directory${NC}"
    exit 1
}
echo -e "${GREEN}✓ In directory: $(pwd)${NC}"
echo ""

# Step 2: Run flutter command
echo -e "${YELLOW}Step 2: Running Flutter code generation...${NC}"
echo "Running: flutter clean && pub get && build_runner && gen-l10n"

# Flutter clean
echo -e "running flutter clean...\n"
if ! flutter clean; then
    echo -e "${RED}Error: flutter clean failed${NC}"
    exit 1
fi

# Flutter pub get
echo -e "running flutter pub get...\n"
if ! flutter pub get; then
    echo -e "${RED}Error: flutter pub get failed${NC}"
    exit 1
fi

# Build runner
echo -e "running build runner...\n"
if ! dart run build_runner build -d; then
    echo -e "${RED}Error: build runner failed${NC}"
    exit 1
fi

# Generate l10n
if ! flutter gen-l10n; then
    echo -e "${RED}Error: flutter gen-l10n failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Code generation completed${NC}"
echo ""

# Step 3: Copy source directory to target location
echo -e "${YELLOW}Step 3: Copying project to target location...${NC}"

# Remove old folder at destination if it exists
if [ -d "$TARGET_DIR" ]; then
    echo "Removing existing folder at destination..."
    rm -rf "$TARGET_DIR"
fi

# Copy the entire source directory
echo "Copying from: $SOURCE_DIR"
echo "Copying to: $TARGET_DIR"

if cp -R "$SOURCE_DIR" "$TARGET_DIR"; then
    echo -e "${GREEN}✓ Project copied successfully${NC}"
else
    echo -e "${RED}Error: Failed to copy project${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Sync completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"