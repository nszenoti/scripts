#!/bin/bash

# FIrst TIme
# Make Script Executable
# chmod +x fix_barrel_import.sh

# Usage: fix_barrel_import.sh <filename.dart>

# NOT WORKING !!!!

# Check if a file is provided
if [ -z "$1" ]; then
  echo "Please provide a Dart file."
  exit 1
fi

file=$1

# Check if the file exists
if [ ! -f "$file" ]; then
  echo "File $file does not exist."
  exit 1
fi

# # Print the current contents of the file
# echo "Current contents of the file:"
# cat "$file"

# Use sed to replace the imports
# This ignores lines starting with 'package:' and replaces file imports with 'index.dart'
sed -i.bak -E "/import\s+(['\"][^'\"]*)\/[^\/]+\/[^\/]+\.dart(['\"])/!s|(import\s+['\"][^'\"]*/)[^/]+/[^/]+\.dart(['\"])|\1index.dart\2|" "$file"

# # Print the modified contents of the file
# echo "Modified contents of the file:"
# cat "$file"

echo "Import statements modified in $file"
