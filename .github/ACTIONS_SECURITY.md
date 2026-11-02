# Actions security

The sole tracked workflow is Pages. Required PR check: **Build and validate**.
Checkout does not persist credentials. Default permissions are empty; build has
contents/read and pages/read. Deployment requires main and a non-PR event, with
pages/write and id-token/write in the github-pages environment.

Every external action uses a reviewed full commit SHA. The generated
`.github/workflows/actions.lock` also covers transitive action dependencies.
Version comments are informational; the SHA and lockfile are authoritative.

Review official releases before upgrading. Generate with github/gh-actions-lock
v0.4.0, then restore the reviewed full SHA references if the tool rewrites them
to tags. Never hand-edit actions.lock. Verify with:

```sh
gh actions-lock --verify
python3 -B -m unittest tests.test_workflow_security -v
actionlint
```

The tool's advisory about bare SHA references does not weaken workflow pins.
Compare lockfile hashes before and after regeneration. Review any changed
transitive action before accepting it. GitHub-managed Dependabot and CodeQL are
configured through repository settings and do not add tracked workflow files.
