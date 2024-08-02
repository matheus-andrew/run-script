#!/bin/bash

# Directory to hold reports
REPORT_DIR="cucumber-reports"

# Ensure the report directory exists
if [ ! -d "$REPORT_DIR" ]; then
    mkdir "$REPORT_DIR"
    echo "Directory $REPORT_DIR created."
fi

CYAN='\033[0;36m'
COLOR_OFF='\033[0m'

# Run tests multiple times with different report filenames
for i in $(seq 1 $1); do
    echo -e "${CYAN}Start running iteration $i...%{COLOR_OFF}"

    # Run tests and generate report
    mvn clean install
    echo -e "${CYAN}Maven runner completed.%{COLOR_OFF}"

    # Copy the report and rename it
    cp target/cucumber.html "$REPORT_DIR/cucumber_$i.html"
    echo -e "${CYAN}Success copied HTML report.%{COLOR_OFF}"

    # Optional: Pause between runs if needed
    sleep 5

    # Kill all Chrome processes
    pkill -f chrome
    echo -e "${CYAN}All Chrome processes terminated.%{COLOR_OFF}"
done
