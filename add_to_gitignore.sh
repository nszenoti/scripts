#!/bin/bash

# First time
# give it exeuatable permission
# chmod +x add_to_gitignore.sh

# Does following
# 1. Check if input is provided
# 2. If input is a valid file path, add it to .gitignore if absent
# 3. If input is a filename, then
# 3. Find matching files
# 4. If only one match, use it directly, otherwise
# 5. Display choices
# 6. Add to .gitignore if not already present


# Check if filename is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

INPUT="$1"

# Check if input is a valid file path
if [ -f "$INPUT" ]; then
    # Convert absolute path to relative if needed
    path="${INPUT#./}"

    # Add to .gitignore if not already present
    if grep -Fxq "$path" .gitignore; then
        echo "File '$path' is already in .gitignore"
    else
        echo "$path" >> .gitignore
        echo "Added '$path' to .gitignore"
    fi
    exit 0
fi


FILENAME="$1"

# Find matching files
matches=($(find . -type f -name "$FILENAME"))

# Check if any file was found
if [ ${#matches[@]} -eq 0 ]; then
    echo "No files found with name: $FILENAME"
    exit 1
fi

# If only one match, use it directly
if [ ${#matches[@]} -eq 1 ]; then
    selected_file="${matches[0]}"
else
    # Display choices
    echo "Multiple files found. Select one:"
    for i in "${!matches[@]}"; do
        echo "$((i + 1)). ${matches[i]}"
    done

    # Read user input
    read -p "Enter choice (1-${#matches[@]}): " choice

    # Validate choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#matches[@]} ]; then
        echo "Invalid choice"
        exit 1
    fi

    selected_file="${matches[$((choice - 1))]}"
fi

# Convert absolute path to relative path
#relative_path=$(realpath --relative-to="$(pwd)" "$selected_file")
relative_path="${selected_file#./}"

# Add to .gitignore if not already present
if grep -Fxq "$relative_path" .gitignore; then
    echo "File '$relative_path' is already in .gitignore"
else
    echo "$relative_path" >> .gitignore
    echo "Added '$relative_path' to .gitignore"
fi
