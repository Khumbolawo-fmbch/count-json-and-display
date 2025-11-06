#!/bin/bash

# Usage: ./verify_summary.sh /path/to/json/files
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/json/folder"
  exit 1
fi

FOLDER="$1"
CSV_FILE="$FOLDER/verification_summary.csv"

# Initialize counters and lists
total=0
success=0
failed=0
false_positive=0
false_negative=0
false_positive_files=()
false_negative_files=()

# Create CSV header
echo "filename,verified,matches_id,false_positive,false_negative,similarity_score,threshold_used" > "$CSV_FILE"

# Loop through JSON files
for file in "$FOLDER"/*.json; do
  [ -e "$file" ] || continue

  verified=$(jq -r '.verification.verified' "$file")
  matches_id=$(jq -r '.matches_id // false' "$file")
  similarity_score=$(jq -r '.verification.similarity_score // 0.0' "$file")
  threshold_used=$(jq -r '.verification.threshold_used // 0.0' "$file")

  if [ "$verified" != "null" ]; then
    ((total++))

    if [ "$verified" = "true" ]; then
      ((success++))
    else
      ((failed++))
    fi

    fp="false"
    fn="false"

    # Apply logic matrix
    if [ "$matches_id" = "true" ] && [ "$verified" = "false" ]; then
      ((false_negative++))
      fn="true"
      false_negative_files+=("$file")
    elif [ "$matches_id" = "false" ] && [ "$verified" = "true" ]; then
      ((false_positive++))
      fp="true"
      false_positive_files+=("$file")
    fi

    # Write row to CSV
    echo "$(basename "$file"),$verified,$matches_id,$fp,$fn,$similarity_score,$threshold_used" >> "$CSV_FILE"
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

# Calculate percentages if total > 0
if [ "$total" -gt 0 ]; then
  success_rate=$(awk "BEGIN {printf \"%.2f\", ($success/$total)*100}")
  fp_rate=$(awk "BEGIN {printf \"%.2f\", ($false_positive/$total)*100}")
  fn_rate=$(awk "BEGIN {printf \"%.2f\", ($false_negative/$total)*100}")

  echo "Success rate:                  $success_rate%"
  echo "False positive rate:           $fp_rate%"
  echo "False negative rate:           $fn_rate%"
else
  echo "No verifications found."
fi

# List false positive and negative files
echo
if [ "$false_positive" -gt 0 ]; then
  echo "⚠️  False Positive Files:"
  for f in "${false_positive_files[@]}"; do
    echo "   → $f"
  done
fi

if [ "$false_negative" -gt 0 ]; then
  echo
  echo "⚠️  False Negative Files:"
  for f in "${false_negative_files[@]}"; do
    echo "   → $f"
  done
fi

echo
echo "CSV summary saved to: $CSV_FILE"
echo "Done ✅"
