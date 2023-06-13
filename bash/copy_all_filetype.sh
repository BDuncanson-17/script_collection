#!/bin/bash

# Default values
source_dir=""
destination_dir=""
file_extension="sh"

# Function to display script usage
display_help() {
  echo "Usage: $0 [-h] [-d destination] [-s source] [-e extension]"
  echo "Copy files with a specific extension recursively."
  echo ""
  echo "Options:"
  echo "  -h, --help                Display this help message."
  echo "  -d, --destination <dir>   Specify the destination directory."
  echo "  -s, --source <dir>        Specify the source directory."
  echo "  -e, --extension <ext>     Specify the file extension (default: sh)."
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -h|--help)
    display_help
    exit 0
    ;;
  -d|--destination)
    destination_dir="$2"
    shift
    shift
    ;;
  -s|--source)
    source_dir="$2"
    shift
    shift
    ;;
  -e|--extension)
    file_extension="$2"
    shift
    shift
    ;;
  *)
    echo "Invalid argument: $1"
    display_help
    exit 1
    ;;
  esac
done

# Check if source directory is provided
if [ -z "$source_dir" ]; then
  echo "Error: Source directory not specified."
  display_help
  exit 1
fi

# Check if destination directory is provided
if [ -z "$destination_dir" ]; then
  echo "Error: Destination directory not specified."
  display_help
  exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Find and copy files with specified extension recursively
find "$source_dir" -type f -name "*.$file_extension" -exec cp -v {} "$destination_dir" \;
