# CodeQL Advanced GH Action FAILS:

https://github.com/SPkHz/SPkHz.github.io/actions/runs/22938514852/job/66574999266#step:9:4


Analyze (ruby) This job attempted to run with improved incremental analysis but it did not complete successfully. One possible reason for this is disk space constraints, since improved incremental analysis can require a
significant amount of disk space for some repositories. This failure has been recorded in the Actions cache, so the next CodeQL analysis will run without improved incremental analysis. If you want to enable improved incremental
analysis, try increasing the disk space available to the runner. If that doesn't help, contact GitHub Support for further assistance.

## Perform CodeQL Analysis

```bash
Run github/codeql-action/analyze@v3
  with:
    category: /language:ruby
    output: ../results
    upload: always
    skip-queries: false
    checkout_path: /home/runner/work/SPkHz.github.io/SPkHz.github.io
    upload-database: true
    wait-for-processing: true
    token: ***
    matrix: {
    "language": "ruby",
    "build-mode": "none"
  }
    expect-error: false
  env:
    CODEQL_ACTION_FEATURE_MULTI_LANGUAGE: false
    CODEQL_ACTION_FEATURE_SANDWICH: false
    CODEQL_ACTION_FEATURE_SARIF_COMBINE: true
    CODEQL_ACTION_FEATURE_WILL_UPLOAD: true
    CODEQL_ACTION_VERSION: 4.32.6
    JOB_RUN_UUID: 4c0987fb-07a0-4d18-94cb-2c1d14a2827c
    CODEQL_ACTION_INIT_HAS_RUN: true
    CODEQL_ACTION_ANALYSIS_KEY: .github/workflows/codeql.yml:analyze
    CODEQL_WORKFLOW_STARTED_AT: 2026-03-11T05:37:45.671Z
    CODEQL_RAM: 14576
    CODEQL_THREADS: 4
Error: Loaded a configuration file for version '4.32.6', but running version '3.32.6'

```

## Analyze Ruby errors:
```
0s
Post job cleanup.
Error: analyze post-action step failed: Loaded a configuration file for version '4.32.6', but running version '3.32.6'
```
