#!/bin/bash

# Path to the allure-results folder
ALLURE_RESULTS_DIR=$1

# Check if the allure-results directory exists
if [ ! -d "$ALLURE_RESULTS_DIR" ]; then
  echo "Error: $ALLURE_RESULTS_DIR directory does not exist!"
  exit 1
fi

# Initialize counters
PASSED=0
FAILED=0
SKIPPED=0

# Loop through all the allure result files (*.json)
for result_file in "$ALLURE_RESULTS_DIR"/*.json; do
  # Check if the file exists
  if [ ! -f "$result_file" ]; then
    echo "Error: No allure result files found in $ALLURE_RESULTS_DIR!"
    continue
  fi

  # Use jq to parse the JSON and count the occurrences of each test status (passed, failed, skipped)
  PASSED=$((PASSED + $(jq '[.steps[]? | select(.status == "passed")] | length' "$result_file")))
  FAILED=$((FAILED + $(jq '[.steps[]? | select(.status == "failed")] | length' "$result_file")))
  SKIPPED=$((SKIPPED + $(jq '[.steps[]? | select(.status == "skipped")] | length' "$result_file")))
done

# Output the results
echo "$PASSED-$FAILED-$SKIPPED"
