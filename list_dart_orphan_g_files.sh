#!/bin/bash

# Function to find orphaned *.g.dart files and list them
list_orphan_g_files_v1() {
    # Find all *.g.dart files
    find . -type f -name '*.g.dart' | while read g_file; do
        # Generate the corresponding *.dart file name
        dart_file="${g_file%.g.dart}.dart"

        # Check if the *.dart file exists
        if [ ! -f "$dart_file" ]; then
            echo "$g_file"
            count+=1
        fi
    done
}



# Function to list orphaned *.g.dart files and store names in a variable
list_orphan_g_files() {
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

    # Print the orphaned files
    if [ ${#orphan_files[@]} -gt 0 ]; then
        echo "Orphaned *.g.dart files:"
        echo "$orphan_files_list"
        echo "Total orphaned *.g.dart files found: ${#orphan_files[@]}"
    else
        echo "No orphaned *.g.dart files found."
    fi
}

# Check if the script is executed directly
if [ "$0" = "$BASH_SOURCE" ]; then
    # If executed directly, call delete_orphan_g_files function
    # Call the function to delete orphaned *.g.dart files
    list_orphan_g_files_v1
fi