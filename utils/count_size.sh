#!/bin/bash

# Calculate the total size in gigabytes from a file containing sizes with units.
#
# Usage: ./calculate_total_size.sh <input_file>
#   - input_file: A file containing sizes with units (e.g., 10 GB, 500 MB, 2 kB, 100 bytes).
#
# This Bash script reads the input file, converts sizes to gigabytes, and prints the total size.

# Check if the input file is provided as a command-line argument
if [ -z "$1" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

INPUT_FILE_PATH="$1"

# Check if the input file exists
if [ ! -e "$INPUT_FILE_PATH" ]; then
  echo "Error: The specified input file does not exist."
  exit 1
fi

# Process each line in the input file
awk 'NF > 0 {
  if (! /^[0-9]+(\.[0-9]+)?[[:space:]]*(G|GB|M|MB|kB|bytes)[[:space:]]*$/) {
    print "Error in line " NR ": " $0 "Each line should be in the format \"<size> <unit> (G/GB/M/MB/kB/bytes)\"."
    exit 1
  }

  size = $1
  unit = toupper(substr($2, 1, 1))

  if (unit == "G") {
         sum += size
  } else if (unit == "M") {
      if (size >= 1024) {
          sum += size / 1024
      } else {
          sum += size
      }
  } else if (unit == "KB") {
      if (size >= 1024) {
          sum += size / (1024 * 1024)
      } else {
          sum += size / 1024
      }
  } else {
      sum += size / (1024 * 1024 * 1024)
  }



} END {
  printf "%.2f GB\n", sum
}' "$INPUT_FILE_PATH"
