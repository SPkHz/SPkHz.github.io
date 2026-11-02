# Pages security remediation design

Approved scope: keep Jekyll and publish only validated `_site` output through
one official GitHub Pages workflow. The public URL is https://spkhz.github.io/;
no custom domain is introduced. The accompanying implementation plan defines
the exact versions, action SHAs, tests, and acceptance matrix.

Use Ruby 3.3.13, Bundler 4.0.15, Node 24.22.1, npm 11.19.1, Prettier 3.8.3,
and PurgeCSS 8.0.0 in a locked rootless Podman devcontainer. Install npm
dependencies with lifecycle scripts disabled and Ruby dependencies frozen.

Remove vendored setup-python fixtures and obsolete automation and integrations.
Retain active Jekyll features and the static notebook. Replace published profile
images with the supplied KiCad board and a deterministic 1200 by 630 social card.
Keep original portrait binaries in source/history but exclude them from output.

Publication validators reject development files, portrait leakage, unsafe links,
special files, empty output, mixed content, and unsafe third-party executable
resources. Preserve `_scripts` as a build input, require generated search data,
and reject `_scripts` in output. Publish `.well-known/security.txt` with private
advisory reporting and the approved email fallback.

Use six reviewed SHA-pinned actions with a generated actions.lock, empty default
permissions, read-only build permissions, and a separate main-only deployment
job. The sole required PR check is `Build and validate`. Keep GitHub-managed
Dependabot and CodeQL. Require signed PR-only main updates with zero approvals.

Use signed commits. Push, PR creation, settings changes, merging and deployment
require separate explicit authority. Preserve other worktrees and branch refs.
Heroku remains verification-only and authenticated access needs explicit authority.
Deno commit `4bcea93` is only a source for selected validators; do not merge it.

Before cutover require the complete local verification suite, generated-lock
idempotence, secret/dependency checks, a green hosted build and artifact review.
If cutover fails, restore captured settings and revert through a new PR. The
previous legacy Pages state was already errored, so rollback does not promise
a working deployment.
