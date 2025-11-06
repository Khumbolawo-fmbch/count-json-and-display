# ID Verification Summary Script

This bash script analyzes JSON files containing ID verification results and generates a summary report of successful and failed verifications.

## Prerequisites

Before using this script, ensure you have the following installed:

- Bash shell environment
- `jq` command-line JSON processor

## Installation

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x id_verification_summary.sh
   ```

## Usage

Run the script by providing the path to the folder containing your JSON verification files:

```bash
./id_verification_summary.sh /path/to/json/folder
```

### Expected JSON Format

The script expects JSON files in the specified folder to have the following structure:

```json
{
  "verification": {
    "verified": true|false,
    "similarity_score": num
  }
}
```

## Output

The script will display a summary report that includes:

- Total number of verifications attempted
- Number of successful verifications
- Number of failed verifications
- Success rate (as a percentage)

Example output:

```
---------------------------------------------
Verification Summary
---------------------------------------------
Folder: /path/to/json/folder
Total verifications attempted: 100
Successful verifications:      85
Failed verifications:          15
---------------------------------------------
Success rate:                  85.00%
```

## Error Handling

- If no folder path is provided, the script will display usage instructions
- If no JSON files are found in the specified folder, the script will indicate that no verifications were found
- Files that don't contain the expected JSON structure will be skipped

## Notes

- The script only processes files with the `.json` extension
- Files without a valid `verification.verified` field will be ignored in the count
- The success rate is calculated only if at least one verification was found
