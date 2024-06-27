#!/bin/bash

# script to generate barrel dart file of all sibbling files in current folder

# usage >> `dart_barrel_file_gen.sh barrel_filename.dart``

# NOTE: Run below command first time to grant permission to this script to run from anywhere
# chmod +x ~/scripts/dart_barrel_file_gen.sh

# Define the default filename for the barrel file
DEFAULT_FILENAME="index.dart"

# Get the filename from user input (if provided)
if [ $# -eq 0 ]; then
    BARREL_FILE=$DEFAULT_FILENAME
else
    BARREL_FILE=$1
fi

# Check if the specified file already exists and delete it
if [ -f $BARREL_FILE ]; then
    rm $BARREL_FILE
fi

# Get all Dart files in the current directory (excluding the barrel file itself)
FILES=$(ls *.dart | grep -v $BARREL_FILE)

# Create or overwrite the barrel file and export all sibling files
echo "// Auto-generated barrel file" >> $BARREL_FILE
for FILE in $FILES; do
    echo "export '$FILE';" >> $BARREL_FILE
done

echo "Barrel file $BARREL_FILE created successfully."
