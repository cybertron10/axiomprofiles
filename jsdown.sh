#!/bin/bash

# Set the destination folder where the JS files will be saved
destination_folder="jsfiles"

# Set the timeout value in seconds
timeout_seconds=10

# Read the URLs from the text file
while read -r url; do
  # Extract the file name from the URL
  file_name=$(basename "$url")

  # Download the file using curl with timeout and save it to the destination folder
  curl -L --create-dirs --max-time "$timeout_seconds" -o "$destination_folder/$file_name" "$url" &
done < jsurls.txt

# Wait for all downloads to complete
wait
