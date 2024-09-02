#!/bin/bash

# Make the script executable
# Run this command only for first time in your system (ie before script is ever used)
# chmod +x add_to_gitignore.sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <barrelfilename> <filename>"
  exit 1
fi

# Assign arguments to variables
barrelfilename="$1"
filename="$2"

# # Check if the file to add exists
# if [ ! -f "$filename" ]; then
#   echo "Error: File '$filename' does not exist."
#   exit 1
# fi

# Add the filename to the barrel file if it's not already there
if ! grep -q "$filename" "$barrelfilename"; then
  echo -e "export '$filename';" >> "$barrelfilename"
  echo "Added '$filename' to '$barrelfilename'."
else
  echo "'$filename' is already in '$barrelfilename'."
fi