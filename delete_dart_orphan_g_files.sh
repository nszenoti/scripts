#!/bin/bash

    # # Function to find and delete orphaned *.g.dart files
    # delete_orphan_g_files() {
    #     # Find all *.g.dart files
    #     find . -type f -name '*.g.dart' | while read g_file; do
    #         # Generate the corresponding *.dart file name
    #         dart_file="${g_file%.g.dart}.dart"

    #         # Check if the *.dart file exists
    #         if [ ! -f "$dart_file" ]; then
    #             echo "Deleting Orphaned *.g.dart file: $g_file"
    #             #rm -f "$g_file"  # Delete the orphaned *.g.dart file
    #             mv "$g_file" ~/.Trash/   # Move the file to the Trash ( = cmd + del)
    #         fi
    #     done
    # }

# Function to find and delete orphaned *.g.dart files
ls_rmt_orphan_g_files() {
    # Declare an array locally to store orphaned files
    local -a orphan_files=()

    # Use find command to list *.g.dart files and process substitution
    while IFS= read -r -d '' g_file; do
        # Generate the corresponding *.dart file name
        dart_file="${g_file%.g.dart}.dart"

        # Check if the *.dart file exists
        if [ ! -f "$dart_file" ]; then
            orphan_files+=("$g_file")
        fi
    done < <(find . -type f -name '*.g.dart' -print0)

    # Store orphaned *.g.dart files in a variable
    orphan_files_list=$(printf '%s\n' "${orphan_files[@]}")
    # Store count of total orphan files
    orphan_count=${#orphan_files[@]}

    # Print the orphaned files (info)
    if [ $orphan_count -gt 0 ]; then
        echo "Orphaned *.g.dart files:"
        echo "$orphan_files_list"
        echo "Total orphaned *.g.dart files found: $orphan_count"
    else
        echo "No orphaned *.g.dart files found."
    fi

    # -------- Delete Files

    if [ $orphan_count -gt 0 ]; then
        # Ask for confirmation before deletion
        read -p "Delete orphaned *.g.dart files? (y/n): " confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            # Find all *.g.dart files
            for g_file in "${orphan_files[@]}"; do
                # Instead of permanent delete (delete it temporary i.e move it to trash (hence safer))
                # rm -f "$g_file"
                echo "Deleting $g_file"
                mv "$g_file" ~/.Trash/   # Move the file to the Trash ( = cmd + del)
            done
            echo "$orphan_count Orphaned files deleted & moved to trash."
        else
            echo "Deletion canceled."
        fi
    fi
}


# Check if the script is executed directly
if [ "$0" = "$BASH_SOURCE" ]; then
    # If executed directly, call delete_orphan_g_files function
    # Call the function to delete orphaned *.g.dart files
    ls_rmt_orphan_g_files
fi