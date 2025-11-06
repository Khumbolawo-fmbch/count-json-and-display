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
./id_verification_summary.sh /path/to/json/folder optional_suffix
```

### Expected JSON Format

The script expects JSON files in the specified folder to have the following structure:

```json
{
  "verification": {
    "verified": true,
    "similarity_score": 40.47,
    "message": "",
    "threshold_used": 0.4,
    "details": {
      "distance": 0.5953,
      "id_bbox": [1741, 442, 2090, 867],
      "live_bbox": [563, 167, 810, 506]
    },
    "matches_id": true
  },
  "saved_files": {
    "raw_id": "/home/transformation/aiapis/insightface_verifications/verification_20251106T140532Z_e4c570ee_id.jpg",
    "raw_live": "/home/transformation/aiapis/insightface_verifications/verification_20251106T140532Z_e4c570ee_live.jpg",
    "annotated_id": "/home/transformation/aiapis/insightface_verifications/verification_20251106T140532Z_e4c570ee_id_annotated.jpg",
    "annotated_live": "/home/transformation/aiapis/insightface_verifications/verification_20251106T140532Z_e4c570ee_live_annotated.jpg",
    "json": "/home/transformation/aiapis/insightface_verifications/verification_20251106T140532Z_e4c570ee_result.json"
  },
  "created_at_utc": "20251106T140532Z"
}
```

## Output

The script will display a summary report that includes:

- Total number of verifications attempted
- Number of successful verifications
- Number of failed verifications
- Success rate (as a percentage)
- False positive rate (as a percentage)
- False negative rate (as a percentage)

Example output:

```
---------------------------------------------
Verification Summary
---------------------------------------------
Folder: /home/transformation/aiapis/insightface_verifications/
Total verifications attempted: 33
Successful verifications:      15
Failed verifications:          18
False positives:               15
False negatives:               0
---------------------------------------------
Success rate:                  45.45%

⚠️  False Positive Files:
   → /home/transformation/aiapis/insightface_verifications//verification_20251105T142129Z_85ce9c27_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251105T142625Z_c313774d_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251105T142759Z_1c9d9c52_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T070720Z_6d06dbab_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T071631Z_c039fd63_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T085252Z_f75dc948_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T094556Z_e1ca1e6f_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T094624Z_47bde18e_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T112739Z_e81913f3_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T113212Z_b08d54d4_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T121540Z_b4d5d17b_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T124932Z_ded32cbb_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T125015Z_c29538dd_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T134117Z_f5ed4f22_result.json
   → /home/transformation/aiapis/insightface_verifications//verification_20251106T134142Z_5fc06ad8_result.json

Done ✅
```

The script also generates a csv file with the results of a test run tabulated. You may name your test run by passing an extra argument to the script at runtime.

## Error Handling

- If no folder path is provided, the script will display usage instructions
- If no JSON files are found in the specified folder, the script will indicate that no verifications were found
- Files that don't contain the expected JSON structure will be skipped

## Notes

- The script only processes files with the `.json` extension
- Files without a valid `verification.verified` field will be ignored in the count
- The success rate is calculated only if at least one verification was found
