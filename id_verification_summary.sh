#!/bin/bash

# Usage: ./verify_summary.sh /path/to/json/files
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/json/folder"
  exit 1
fi

FOLDER="$1"

# Initialize counters
total=0
success=0
failed=0
false_positive=0
false_negative=0

# Loop through all JSON files in the folder
for file in "$FOLDER"/*.json; do
  [ -e "$file" ] || continue

  # Extract fields using jq
  verified=$(jq -r '.verification.verified' "$file")
  matches_id=$(jq -r '.matches_id // false' "$file")  # default false if missing

  if [ "$verified" != "null" ]; then
    ((total++))

    # Count success/failure
    if [ "$verified" = "true" ]; then
      ((success++))
    else
      ((failed++))
    fi

    # Apply your matrix logic:
    # 1. matches_id=true,  verified=true   -> FP=0, FN=0
    # 2. matches_id=false, verified=true   -> FP=1, FN=0
    # 3. matches_id=true,  verified=false  -> FP=0, FN=1
    # 4. matches_id=false, verified=false  -> FP=0, FN=0

    if [ "$matches_id" = "true" ] && [ "$verified" = "false" ]; then
      ((false_negative++))
    elif [ "$matches_id" = "false" ] && [ "$verified" = "true" ]; then
      ((false_positive++))
    fi
  fi
done

# Print summary
echo "---------------------------------------------"
echo "Verification Summary"
echo "---------------------------------------------"
echo "Folder: $FOLDER"
echo "Total verifications attempted: $total"
echo "Successful verifications:      $success"
echo "Failed verifications:          $failed"
echo "False positives:               $false_positive"
echo "False negatives:               $false_negative"
echo "---------------------------------------------"

if [ "$total" -gt 0 ]; then
  rate=$(awk "BEGIN {printf \"%.2f\", ($success/$total)*100}")
  echo "Success rate:                  $rate%"
else
  echo "No verifications found."
fi
