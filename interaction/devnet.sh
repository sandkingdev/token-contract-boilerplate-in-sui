#!/bin/bash

# Define variables
GAS_BUDGET=20000000
# FUNCTION_NAME="mint"
MODULE_NAME="your_module"
GAS_BUDGET_CALL=10000000
OUTPUT_FILE="objects.txt"

echo "" > $OUTPUT_FILE

# Deploy the contract
# PUBLISH_OUTPUT=$(sui client publish --gas-budget $GAS_BUDGET $PACKAGE_PATH --skip-fetch-latest-git-deps --skip-dependency-verification)
PUBLISH_OUTPUT=$(sui client publish --skip-fetch-latest-git-deps --skip-dependency-verification)
echo "Publish Output: $PUBLISH_OUTPUT" >> $OUTPUT_FILE

# Extract the package ID
PACKAGE_ID=$(echo "$PUBLISH_OUTPUT" | grep -oP 'PackageID:\s*\K(\w+)')
echo "Package ID: $PACKAGE_ID" >> $OUTPUT_FILE

# Extract the "Object Changes" block
OBJECT_CHANGES=$(echo "$PUBLISH_OUTPUT" | awk '/Object Changes/,/Mutated Objects/')
echo "$OBJECT_CHANGES" >> $OUTPUT_FILE

# # Call a function from the deployed contract
# CALL_OUTPUT=$(sui client call --function $FUNCTION_NAME --module $MODULE_NAME --package $PACKAGE_ID --gas-budget $GAS_BUDGET_CALL)
# echo "Call Output: $CALL_OUTPUT"
