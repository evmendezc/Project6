#!/bin/bash

# This script creates a backup of files modified on or after a specified mod_date.


# Validate the input arguments
if [ $# -ne 2 ];
then
    echo "Usage: $0 mod_date backup_dirs"
    exit 1
fi

mod_date=$1
backup_dirs=$2

# Check if mod_date is a valid date
if ! date -d "$mod_date" &>/dev/null;
then
    echo "Error: Invalid mod_date format"
    exit 1
fi

# Check if backup_dirs file exists
if [ ! -f "$backup_dirs" ];
then
    echo "Error: backup_dirs file not found"
    exit 1
fi

# Get the current date for the backup filename
curr_date=$(date +%Y-%m-%d)

# Create the backup file name using mod_date and curr_date
backup_filename="${mod_date}_TO_${curr_date}_backups.tgz"

# Prepare a list of files to backup
backup_files=""

# Read each directory listed in the backup_dirs file
while IFS= read -r dir; do
    # Check if the directory exists
    if [ ! -d "$dir" ]; then
        echo "Warning: Directory $dir does not exist, skipping."
        continue
    fi

    # Find all files modified on or after mod_date and add them to the backup list
    modified_files=$(find "$dir" -type f -newermt "$mod_date")

    # Add modified files to the backup_files string
    backup_files="$backup_files $modified_files"
done < "$backup_dirs"

# Check if there are any files to back up
if [ -z "$backup_files" ]; then
    echo "No files to backup. Exiting."
    exit 0
fi

# Create the tar.gz backup
echo "Creating backup file: $backup_filename"
tar -czf "$backup_filename" "$backup_files"

echo "Backup completed successfully!"
