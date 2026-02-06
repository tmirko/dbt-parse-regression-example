#!/bin/bash
set -e

echo "=========================================="
echo "Running both versions for comparison"
echo "=========================================="

cd "$(dirname "$0")"

echo ""
echo "PART 1: Testing dbt-bigquery 1.9.1"
echo "-----------------------------------"
./test_v1.9.1.sh

echo ""
echo ""
echo "PART 2: Testing dbt-bigquery 1.9.2"
echo "-----------------------------------"
./test_v1.9.2.sh

echo ""
echo "=========================================="
echo "Comparison complete!"
echo "=========================================="
echo ""
echo "Compare the 'real' times above to see the regression."
