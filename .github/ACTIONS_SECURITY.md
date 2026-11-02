# Actions security

The sole tracked workflow is Pages. Required PR check: **Build and validate**.
Checkout does not persist credentials. Default permissions are empty; build has
contents/read and pages/read. Deployment requires main and a non-PR event, with
pages/write and id-token/write in the github-pages environment.

Every external action names an exact reviewed release. The generated
`.github/workflows/actions.lock` pins those releases and their transitive action
dependencies to reviewed full commit SHAs. The runner enforces the lockfile;
moving a release tag does not authorize a different commit.

Review official releases before upgrading. Update the exact release reference,
generate with github/gh-actions-lock v0.4.0, and review every changed commit SHA.
Never hand-edit actions.lock. Verify with:

```sh
gh actions-lock --verify
python3 -B -m unittest tests.test_workflow_security -v
actionlint
```

Compare lockfile hashes before and after regeneration. Review any changed
transitive action before accepting it. GitHub-managed Dependabot and CodeQL are
configured through repository settings and do not add tracked workflow files.
