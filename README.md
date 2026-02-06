# dbt-bigquery Parse Performance Regression Example

This is a minimal reproducible example demonstrating a performance regression in `dbt parse` between dbt-bigquery versions 1.9.1 and 1.9.2.

## Problem Description

Between dbt-bigquery 1.9.1 and 1.9.2, the `dbt parse` command shows significant performance degradation (typically 2-3x slower). This regression affects development workflows where parse is run frequently.

## Project Structure

```
dbt-parse-regression-example/
├── pyproject.toml              # UV project configuration
├── dbt_project/
│   ├── dbt_project.yml        # dbt project config
│   ├── profiles.yml           # BigQuery profile (dummy credentials)
│   └── models/                # 10 simple models with BigQuery configs
│       ├── example_model_01.sql
│       ├── example_model_02.sql
│       └── ...
├── test_v1.9.1.sh             # Test script for version 1.9.1
├── test_v1.9.2.sh             # Test script for version 1.9.2
└── run_comparison.sh          # Run both versions and compare
```

## Prerequisites

- Python 3.11.14
- [uv](https://github.com/astral-sh/uv) package manager installed

To install uv:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Quick Start

### Option 1: Run Automated Comparison

```bash
cd /home/dagster/projects/dbt-parse-regression-example
./run_comparison.sh
```

This will:
1. Test dbt-bigquery 1.9.1 (3 parse runs)
2. Test dbt-bigquery 1.9.2 (3 parse runs)
3. Display timing comparison

### Option 2: Test Individual Versions

Test version 1.9.1:
```bash
./test_v1.9.1.sh
```

Test version 1.9.2:
```bash
./test_v1.9.2.sh
```

## Manual Testing

If you prefer to run commands manually:

```bash
# Initialize uv environment
cd /home/dagster/projects/dbt-parse-regression-example
uv venv
source .venv/bin/activate

# Test with 1.9.1
uv pip install "dbt-bigquery==1.9.1"
cd dbt_project
rm -rf target/
time dbt parse --profiles-dir . --quiet
cd ..

# Test with 1.9.2
uv pip install "dbt-bigquery==1.9.2"
cd dbt_project
rm -rf target/
time dbt parse --profiles-dir . --quiet
cd ..
```

## Expected Results

Based on observed regression patterns:

| Version | Parse Time (approx) | Relative Speed |
|---------|-------------------|----------------|
| 1.9.1   | ~2-4 seconds      | Baseline (1x)  |
| 1.9.2   | ~6-12 seconds     | 2-3x slower    |

Exact timings will vary by system, but the regression ratio should be consistent.

## Project Contents

The example includes:
- **10 simple dbt models** with typical BigQuery configurations:
  - Partitioning
  - Clustering
  - Incremental materialization
  - Table materialization
  - View materialization
  - Config blocks
  - Refs between models
  - Labels

- **No actual BigQuery connection required** - the parse command validates SQL structure without connecting to a database

## What This Demonstrates

This minimal example isolates the parse performance issue by:
1. Using only dbt-bigquery (no other plugins)
2. Including realistic but simple BigQuery configurations
3. Requiring no authentication or actual database connection
4. Using automated scripts for consistent, reproducible results

## Notes

- The dummy BigQuery project/dataset in `profiles.yml` is intentional - parse doesn't require real credentials
- Target directory is cleaned between runs to ensure fair comparison
- Each version is tested 3 times to account for variance
- The regression is in the dbt framework's parse logic, not BigQuery itself

## System Information

To report system specs when filing issues:

```bash
uv --version
python --version
uname -a
```

## For Maintainers

This example can be used to:
- Profile parse performance between versions
- Bisect commits to find the regression source
- Test performance improvements
- Validate fixes before release

To profile in detail:
```bash
cd dbt_project
python -m cProfile -o parse.prof $(which dbt) parse --profiles-dir . --quiet
python -m pstats parse.prof
```

## License

This example is provided as-is for debugging purposes. Feel free to modify and share
