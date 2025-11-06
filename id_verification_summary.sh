#!/bin/bash

# Check if a folder path was provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/json/folder"
  exit 1
fi

# The first argument is the folder path
FOLDER="$1"

# Initialize counters
total=0
success=0
failed=0

# Loop through all JSON files in the folder
for file in "$FOLDER"/*.json; do
  # Skip if no JSON files exist
  [ -e "$file" ] || continue

  # Extract "verified" value using jq
  verified=$(jq -r '.verification.verified' "$file")

  if [ "$verified" != "null" ]; then
    ((total++))
    if [ "$verified" = "true" ]; then
      ((success++))
    else
      ((failed++))
    fi
  fi
done

# Print the results
echo "---------------------------------------------"
echo "Verification Summary"
echo "---------------------------------------------"
echo "Folder: $FOLDER"
echo "Total verifications attempted: $total"
echo "Successful verifications:      $success"
echo "Failed verifications:          $failed"
echo "---------------------------------------------"

# Optional: success rate
if [ "$total" -gt 0 ]; then
  rate=$(awk "BEGIN {printf \"%.2f\", ($success/$total)*100}")
  echo "Success rate:                  $rate%"
else
  echo "No verifications found."
fi
