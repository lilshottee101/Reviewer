#!/bin/bash
 
# Check if three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <number_of_lines> <source_directory> <destination_directory>"
    exit 1
fi
 
num_lines="$1"
source_directory="$2"
destination_directory="$3"
 
# Check if source directory exists
if [ ! -d "$source_directory" ]; then
    echo "Error: Source directory '$source_directory' not found."
    exit 1
fi
 
# Check if destination directory exists, create if not
if [ ! -d "$destination_directory" ]; then
    mkdir -p "$destination_directory"
fi
 
# Function to process files recursively
process_files() {
    local current_dir="$1"
 
    # Iterate over files in the current directory
    for file in "$current_dir"/*; do
        # Check if file is a regular file
        if [ -f "$file" ]; then
            # Print specified number of lines from the file
            echo "$file"
            head -n "$num_lines" "$file"
 
            # Ask user for input
            read -p "Is this useful? (Y/N): " decision
 
            # Process user input
            case "$decision" in
                [yY]|[yY][eE][sS])
                    echo "Moving file to $destination_directory"
                    mv "$file" "$destination_directory"
                    ;;
                [nN]| [nN][oO])
                    echo "Not moving the file."
                    ;;
                *)
                    echo "Invalid input. Not moving the file."
                    ;;
            esac
        elif [ -d "$file" ]; then
            # Recursively process files in subdirectories
            process_files "$file"
        fi
    done
}
 
# Start processing files
process_files "$source_directory"
