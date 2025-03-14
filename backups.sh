#!/bin/bash

# This script creates a backup of files modified on or after a specified mod_date.


# Validate the input arguments (-ne means not equal)
if [ $# -ne 2 ];
then
    1>&2 printf "Usage: mod_date (e.g. YYYY-MM-DD) backup_dirs"
fi


# Check if mod_date is a valid date
if ! date -d "$1" &>/dev/null;
then
   1>&2 printf "Error: Invalid mod_date format"
fi

# Check if backup_dirs file exists
if [ ! -f "$2" ];
then
    1>&2 printf "Error: backup_dirs file not found"
fi

# Get the current date for the backup filename
curr_date=$(date +%Y-%m-%d)


# Read each directory listed in the backup_dirs file
if [ "$2" == "backup_dirs" ];
   then
       while read -r dir; do
    # Check if the directory exists
	   if [ ! -d "$dir" ]; then
               echo "Warning: Directory $dir does not exist, skipping."
               continue
	   fi
 


    
    # Find all files modified on or after mod_date and add them to the backup list
	   modified_files=$(find "$dir" -type f -newermt "$1" | ls)
    
	   tar -czf "$1"_TO_"$curr_date"_backups.tgz "$modified_files"
	 
    
    
    # Add modified files to the backup_files string
       done < "$2"
fi


echo "Backup completed successfully!"
