#!/bin/bash
set -e

echo "=========================================="
echo "Testing dbt-bigquery 1.9.1 parse performance"
echo "=========================================="

cd "$(dirname "$0")"

# Create/activate virtual environment and install dbt-bigquery 1.9.1
echo "Installing dbt-bigquery==1.9.1..."
rm -rf .venv
uv venv --python 3.11.14
source .venv/bin/activate
uv pip install "dbt-bigquery==1.9.1"

# Check version
echo "Installed version:"
python -c "import importlib.metadata; print('dbt-bigquery:', importlib.metadata.version('dbt-bigquery'))"

# Clean target directory
rm -rf dbt_project/target/

# Run parse 3 times and measure
echo ""
echo "Running dbt parse (3 iterations)..."
echo "---"

for i in {1..3}; do
    rm -rf dbt_project/target/
    echo "Run $i:"
    cd dbt_project
    { time dbt parse --profiles-dir . --quiet ; } 2>&1 | grep real
    cd ..
done

echo ""
echo "Test with 1.9.1 complete!"
