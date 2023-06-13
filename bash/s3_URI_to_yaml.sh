#!/bin/bash

# Description:
# This script lists all the AWS S3 buckets and their contents (objects),
# and writes them in a YAML format to a file named 'buckets.yaml'. 
# Each bucket's objects are listed under its respective bucket name.

# Note: 
# This script assumes you have already configured your AWS CLI with the
# necessary credentials (Access Key, Secret Key, Region, and Output format).
# If not, please run 'aws configure' before executing this script.

# Please install the AWS CLI and jq tool before running this script.

# Clear out the old file if it exists, or create a new file
OUTPUT_FILE="buckets.yaml"
> $OUTPUT_FILE  

# List all S3 buckets using AWS CLI
# Query syntax is used to extract only the Name field from the response.
buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# Loop over each bucket
for bucket in $buckets
do
    # Write the bucket name to the YAML file
    echo "$bucket:" >> $OUTPUT_FILE

    # List objects in the current bucket
    # Query syntax is used to extract only the Key field from the response.
    objects=$(aws s3api list-objects --bucket "$bucket" --query "Contents[].Key" --output text)

    # Loop over each object in the current bucket
    for object in $objects
    do
        # Write the object name to the YAML file, indented under the bucket name
        echo "  - $object" >> $OUTPUT_FILE
    done
done

# Confirm the completion of the YAML file creation
echo "YAML file has been created at $OUTPUT_FILE"
