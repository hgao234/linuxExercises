#!/bin/bash

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "usage: $0 <dir> <n>" 1>&2
    exit 1
fi

dir=$1
n=$2

# Check if directory exists
if [ ! -d "$dir" ]; then
    echo "Error: Directory '$dir' does not exist" 1>&2
    exit 1
fi

# Check if n is a valid number
if ! [[ "$n" =~ ^[0-9]+$ ]]; then
    echo "Error: <n> must be a non-negative integer" 1>&2
    exit 1
fi

# Find and remove files larger than n bytes
# -type f: only files (not directories)
# -size +nc: files larger than n bytes (c = bytes)
# -exec rm {} \;: execute rm on each found file
find "$dir" -type f -size +"$n"c -exec rm {} \;

echo "Removed all files in '$dir' larger than $n bytes"
