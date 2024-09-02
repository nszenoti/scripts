#!/bin/bash

# Make the script executable
# Run this command only for first time in your system (ie before script is ever used)
# chmod +x generate_cubit.sh

# Function to validate filename
validate_filename() {
    local filename="$1"

    # Check if the filename is lowercase and underscore-separated
    if [[ "$filename" =~ ^[a-z_]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to convert filename to PascalCase
to_pascal_case() {
    local filename="$1"
    # Convert filename from lowercase and underscores to PascalCase
    local pascal_case="$(echo "$filename" | awk -F'_' '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' | tr -d '[:space:]')"
    echo "$pascal_case"
}

# Check if exactly one argument is provided and it's not empty
if [ "$#" -ne 1 ] || [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Store the filename argument
FILENAME="$1"

# Validate the filename
if ! validate_filename "$FILENAME"; then
    echo "Error: Filename must be lowercase and underscore-separated. (not including the .dart extension)"
    exit 1
fi

# Convert filename to PascalCase
BASENAME=$(to_pascal_case "$FILENAME")

CLASSNAME="${BASENAME}Cubit"
STATENAME="${BASENAME}State"
STATUSNAME="${BASENAME}Status"
CUBITFILENAME="${FILENAME}_cubit.dart"
STATEFILENAME="${FILENAME}_state.dart"

# Define the content for the Cubit file
CUBIT_CONTENT=$(cat <<EOF
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '${FILENAME}_cubit.g.dart';
part '${STATEFILENAME}';

class ${CLASSNAME} extends Cubit<${STATENAME}> {
  ${CLASSNAME}()
      : super(const ${STATENAME}(
          status: ${STATUSNAME}.initial,
        ));

  // Add your attributes := field/methods
}
EOF
)

# Define the content for the State file
STATE_CONTENT=$(cat <<EOF
part of '${CUBITFILENAME}';

enum ${STATUSNAME} { initial, loading, success, failure }

@CopyWith()
final class ${STATENAME} extends Equatable {
  const ${STATENAME}({
    required this.status,
  });

  final ${STATUSNAME} status;

  // Add more fields and methods as needed

  @override
  List<Object?> get props => [status];
}
EOF
)

# Create the directory
mkdir -p "$FILENAME"

# Create the Cubit file inside the directory
echo "$CUBIT_CONTENT" > "${FILENAME}/${CUBITFILENAME}"
echo "Created ${FILENAME}/${CUBITFILENAME}"

# Create the State file inside the directory
echo "$STATE_CONTENT" > "${FILENAME}/${STATEFILENAME}"
echo "Created ${FILENAME}/${STATEFILENAME}"
