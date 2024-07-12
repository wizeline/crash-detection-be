#!/bin/bash

# File to store the urls
url_file="video_list.txt"

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

# Get the url from the command line argument
url="$1"

# Add the url to the file, sort it, and remove duplicates
echo "$url" >> "$url_file"
sort -u "$url_file" -o "$url_file"

echo "url '$url' added to $url_file"
echo "Current contents of $url_file:"
cat "$url_file" 