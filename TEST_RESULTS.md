# Test Results Summary

## Performance Comparison

Test conducted on: February 6, 2026
System: Linux x86_64

### dbt parse performance (10 models, clean target directory)

#### Latest Test Results (3 iterations per version)

| Version | Run 1 | Run 2 | Run 3 | Average (excl. Run 1) | Relative Speed |
|---------|-------|-------|-------|-----------------------|----------------|
| **1.9.1** | 6.728s | 4.254s | 4.419s | **4.34s** | Baseline (1.0x) |
| **1.9.2** | 16.878s | 10.069s | 10.004s | **10.04s** | **2.3x slower** |

*Note: Run 1 includes initial setup overhead and is typically slower*

### Key Observations

1. **Parse time increased 2.3x** from ~4.3s to ~10.0s (130% regression)
2. The regression is consistent across multiple runs (Runs 2 and 3)
3. Version 1.9.2 installs 17 additional dependencies compared to 1.9.1:
   - New dependencies include: google-cloud-aiplatform, google-genai, jupyter-core, nbformat, and others
   - Total packages: 82 (v1.9.1) → 99 (v1.9.2)
4. The first run shows even more dramatic differences (6.7s vs 16.9s)

### Impact

For developers running `dbt parse` frequently during development:
- 10 parse commands per day = ~57 seconds wasted
- 50 parse commands per day = ~4.8 minutes wasted
- 100 parse commands per day = ~9.5 minutes wasted
- For larger projects with more models, the impact is even greater

### Reproduction

To reproduce these results:

```bash
cd /home/dagster/projects/dbt-parse-regression-example
./run_comparison.sh
```

### Environment Details

- Python: 3.11.14
- UV package manager: latest
- dbt-core: 1.11.3 (installed via dbt-bigquery)
- dbt-bigquery: 1.9.1 vs 1.9.2
- Platform: Linux x86_64
- Models: 10 simple BigQuery models with standard configurations (partitioning, clustering, incremental materialization)

### Test Configuration

- Clean virtual environment created for each version
- Target directory cleaned before each parse run
- Tests run with `--quiet` flag to minimize output noise
- Each version tested 3 times to ensure consistency
