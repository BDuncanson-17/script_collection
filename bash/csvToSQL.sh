#!/bin/bash

# Function to display help message
display_help() {
    echo "Usage: $0 <csv_file> <table_name>"
    echo
    echo "This script converts a CSV file with headers into SQL INSERT statements."
    echo
    echo "Arguments:"
    echo "  csv_file    Path to the CSV file. The file should have headers in the first line."
    echo "  table_name  Name of the SQL table where the data will be inserted."
    echo
    echo "Example:"
    echo "  $0 data.csv my_table"
}

# Check for help option
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_help
    exit 0
fi

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    display_help
    exit 1
fi

# Assign arguments to variables
csv_file="$1"
table_name="$2"

# Check if the CSV file exists
if [ ! -f "$csv_file" ]; then
    echo "Error: File '$csv_file' not found."
    exit 1
fi

# Read the first line to get column headers
IFS=',' read -r -a headers < "$csv_file"

# Start processing the CSV data
tail -n +2 "$csv_file" | while IFS=',' read -r -a row
do
    # Start constructing the SQL statement
    sql="INSERT INTO $table_name ("

    # Add column names
    for header in "${headers[@]}"
    do
        sql+="$header,"
    done

    # Remove the last comma
    sql=${sql%,}
    sql+=") VALUES ("

    # Add row data
    for value in "${row[@]}"
    do
        # Handle single quotes in SQL values
        value=${value//\'/\'\'}
        sql+="'$value',"
    done

    # Remove the last comma and complete the statement
    sql=${sql%,}
    sql+=");"

    # Output the SQL statement
    echo "$sql"
done

