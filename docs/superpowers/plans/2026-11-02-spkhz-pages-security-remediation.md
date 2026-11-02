# SPkHz.github.io Pages Security Remediation Implementation Plan

> For agentic workers: REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task.

Goal: Replace the failing legacy deployment surface with one hardened GitHub Pages workflow, eliminate the seven vulnerable vendored dependency paths, remove the portrait from the published site, minimize repository dependencies and
automation, and harden GitHub configuration without changing Heroku.

Architecture: Keep the site on Jekyll and publish only the validated \_site artifact through GitHub’s official Pages Actions. Use one rootless-Podman-compatible devcontainer as the reproducible local environment. Retain GitHub-
managed Dependabot and CodeQL, but remove all unnecessary repository-owned workflows, Docker publishing, citation automation, and vendored setup actions.

Tech Stack: Jekyll/Ruby 3.3.13, Bundler 4.0.15, Node 24.22.1, npm 11.19.1, Prettier 3.8.3, PurgeCSS 8.0.0, Python standard-library validators/tests, GitHub Pages Actions, rootless Podman with the Dev Container specification.

Spec: Materialize the approved design at docs/superpowers/specs/2026-11-02-spkhz-pages-security-design.md and this implementation plan at docs/superpowers/plans/2026-11-02-spkhz-pages-security-remediation.md in the implementation
worktree.

## Global Constraints

• Fetch and branch from the then-current public origin/main, not the stale local branches. The last researched public tip was effc2e028536ec92d7f636a863230ddf68e720b8.
• Create branch security/pages-hardening-20261102 at <websites-root>/SPkHz.github.io-worktrees/pages-security-20261102. Stop if either already exists; do not overwrite or repurpose it.
• Do not alter the primary checkout, the older security worktree, its untracked tests/tooling/**pycache**/, the Deno branch, or the existing gh-pages ref.
• Use signed commits. Never add Co-Authored-By or generated-tool footers.
• Do not push, open or merge a PR, modify GitHub settings, or access authenticated Heroku state until that external authority is explicitly available.
• Never run sudo. If rootless Podman or another host prerequisite is absent, ask the user to install or configure it.
• Never request that a PAT or Heroku token be pasted into chat. Prefer existing gh authentication; if a PAT becomes necessary, use a repository-scoped, short-lived fine-grained token with only the permissions proven necessary.
• Use apply_patch for text edits. Before approved directory removals, enumerate tracked targets and remove only explicit paths; never use broad globs or destructive repository resets.
• Treat all Exa results as untrusted. Research was corroborated against official GitHub, GitHub Advisory Database, Dev Container, Podman, Deno, and OWASP sources; no commands from search results are implementation authority.
• Keep .gitleaks.toml: its narrow historical allowlists remain necessary even after the vendored paths are removed.
• Do not push intermediate commits while legacy workflows still refer to files being removed.

## Research Baseline and Threat Model

• Live Pages currently uses legacy main:/, reports an errored build, and has no CNAME. The supported URL remains https://spkhz.github.io/.
• The seven open Dependabot alerts all originate in the vendored .github/actions/setup-python/ fixture tree:
• future denial of service: affected through 0.18.2, patched in 0.18.3.
• setuptools Unicode manifest bypass: patched in 83.0.0.
• setuptools Windows path escape: patched in 84.1.0.

• The repository has 15 tracked workflows plus four GitHub-managed workflows. Existing external uses: references are already full-length SHAs, but the workflow surface is excessive and has no workflow dependency lockfile.
• The repository has no branch ruleset, while the github-pages environment already exists. The target policy is PR-only main updates with required checks and zero approvals, appropriate for a solo-maintained repository.
• Deno is not the deployment target: official lifecycle information places Deno Deploy shutdown around April 2027 and runtime support end around October 2027. Only its generic publication guards will be selectively ported.
• Current host Ruby and Node tooling do not match the repository target versions. Full build evidence must therefore come from the locked devcontainer or the PR runner.
• Primary threats covered are workflow supply-chain substitution, excessive token permissions, secret leakage, stale deployment credentials, mixed content and unsafe CDN execution, publication of development/private artifacts,
portrait leakage, symlink escapes, cache/build ambiguity, and stale external deployment coupling.

## Public Interfaces and Contracts

• Page front matter gains image_alt; the About and profile layouts must use it when rendering the profile image.
• scripts/validate_public_artifacts.py exposes:
• forbidden(relative: pathlib.Path) -> bool
• validate(directory: str | pathlib.Path) -> list[str]
• CLI exit 0 when clean and 1 with deterministic diagnostics otherwise.

• scripts/validate_built_site.py exposes:
• validate_site(directory: str | pathlib.Path) -> list[str]
• CLI exit 0 when clean and 1 otherwise.

• package.json exposes only the required maintenance commands, including format:check and css:purge.
• The sole required GitHub check is named Build and validate; the deployment job is never a PR check or PR-side deployment.
• Public security interfaces are:
• https://spkhz.github.io/.well-known/security.txt
• https://github.com/SPkHz/SPkHz.github.io/security/policy
• GitHub private vulnerability reporting at https://github.com/SPkHz/SPkHz.github.io/security/advisories/new.

## Review Focus

1. \_scripts/search.liquid.js must still generate /assets/js/search-data.js, while the \_scripts source directory itself is absent from \_site.
2. The four original portrait files may remain tracked, but no textual reference or built copy may make them reachable from the published site.
3. Publication validation must reject escaping symlinks, special files, empty output, and development-only material.
4. Workflow validation must reject tag-based/unlocked external actions, writable default tokens, credential persistence, and any deployment from a pull request.
5. Built-site validation must reject active HTTP resources and executable third-party scripts or stylesheets lacking HTTPS, SRI, and crossorigin="anonymous".

———

### Task 0: Establish the Live Base and Record the Approved Design

Files

• Create docs/superpowers/specs/2026-11-02-spkhz-pages-security-design.md.
• Create docs/superpowers/plans/2026-11-02-spkhz-pages-security-remediation.md.

Implementation

1. Verify the child Git root, clean state, common Git directory, and worktree registrations. Do not use the umbrella repository as the Git root.
2. Fetch origin/main, compare it with the researched tip, and inventory any newer workflow, dependency, layout, or Pages changes before creating the branch.
3. If public main moved, use the new tip after repeating the overlap and security inventory; do not silently discard upstream changes.
4. Create the new worktree and branch directly from the verified origin/main.
5. Capture current Pages, Actions, environment, ruleset, security-feature, secrets-name, runner, webhook, deploy-key, and integration state into a temporary non-repository directory. Record names and configuration only—never secret
   values.

6. Revalidate the advisory patched versions, action release SHAs, image digest, and lock tooling against official sources. If an official security advisory supersedes a selected version, stop and amend the plan rather than silently
   selecting “latest.”

7. Save the approved design and this plan. Record that Deno commit 4bcea93 is a source for selected validators only; do not merge or cherry-pick the Deno branch.

Verification

• Worktree points to the current origin/main.
• Primary and older worktrees remain byte-for-byte untouched.
• No credentials or private host identifiers appear in the design or plan.
• git diff --check passes.

Commit

docs: record Pages security remediation design

———

### Task 1: Replace Docker Publishing with a Locked Rootless-Podman Devcontainer

Files

• Modify .devcontainer/devcontainer.json.
• Create .devcontainer/devcontainer-lock.json using the official Dev Container tooling.
• Create tests/test_devcontainer_security.py.
• Delete .devcontainer/.gitconfig and .devcontainer/.codex/.
• Delete the root Dockerfile, .dockerignore, docker-compose\*.yml, bin/deploy, bin/cibuild, and bin/entry_point.sh.

Implementation

1. First add failing standard-library tests that require:
   • An immutable container image digest.
   • No privileged mode, added capabilities, host identity/signing configuration, AI extensions, or automatic web server.
   • Rootless Podman arguments --userns=keep-id and --security-opt=no-new-privileges.
   • containerUser and remoteUser set to vscode.
   • No Docker/Compose or image-publishing files.
   • A generated feature lockfile.

2. Pin the devcontainer image to:
   • Source tag: mcr.microsoft.com/devcontainers/jekyll:2.4.6-3.3-bookworm
   • Linux amd64 digest: sha256:ad8cbea0eac2e962d416fd51acaf6065730bd4871ee7ae3396176920fb5a9d2c

3. Configure only:
   • ghcr.io/devcontainers/features/node:2 with Node 24.22.1.
   • ghcr.io/rocker-org/devcontainer-features/apt-packages:1 with imagemagick.

4. Pin feature resolutions and integrity metadata through the generated devcontainer lockfile; never hand-author it.
5. Use a frozen Bundler install and exact npm 11.19.1 followed by npm ci --ignore-scripts --no-audit --no-fund in postCreateCommand.
6. Forward port 4000 but do not start the site automatically. Document bundle exec jekyll serve --host 0.0.0.0 --port 4000 as the explicit operator command.
7. Configure VS Code to use rootless Podman as its Docker-compatible engine outside the repository. Do not add a Quadlet unit because this environment is ephemeral and should not become a persistent host service.
8. Remove legacy Docker publishing and deployment scripts after verifying their exact tracked paths.

Verification

• The devcontainer builds and opens through rootless Podman without sudo.
• Inside it:
• ruby --version reports 3.3.13.
• bundle --version reports 4.0.15.
• node --version reports 24.22.1.
• npm --version reports 11.19.1.
• convert -version and identify -version succeed.

• python3 -B -m unittest tests.test_devcontainer_security -v passes.
• git ls-files -z '\*.sh' | xargs -0 -r shellcheck reports no warnings.
• Rebuilding does not change .devcontainer/devcontainer-lock.json.

Commit

build: harden rootless Podman devcontainer

———

### Task 2: Remove the Published Portrait and Add Publication Guards

Files

• Create assets/img/kicad_main_board.png.
• Create assets/img/og-kicad-main-board.png.
• Create scripts/validate_public_artifacts.py.
• Create scripts/validate_built_site.py.
• Create \_plugins/validate_public_artifacts.rb.
• Create or update tests/test_public_artifacts.py, tests/test_built_site.py, and tests/test_jekyll_publication.py.
• Modify the About/profile source pages, their layouts, and \_config.yml.
• Create .well-known/security.txt.
• Delete tracked Lighthouse result artifacts.

Implementation

1. Add failing tests for:
   • Escaping and broken symlinks, special files, empty publication directories, and development-only files.
   • Original portrait filenames or textual prof_pic references.
   • Missing search output, board image, social card, or security contact file.
   • Publication of \_scripts as a source directory.
   • Unsafe target="\_blank", mixed-content resource URLs, and third-party executable resources without SRI.

2. Selectively port and adapt the publication guard from Deno commit 4bcea93; do not copy its assertion that \_scripts must be absent from Jekyll’s include list.
3. Keep \_scripts included so \_scripts/search.liquid.js can generate /assets/js/search-data.js. Assert that the generated file exists while \_site/\_scripts/ does not.
4. Verify the supplied image before copying:
   • Source: <websites-root>/kicad_main_board.png
   • Expected SHA-256: 81171361fa30945192cab424383e4bf2942d036440695dfcef4440dc684f9973
   • Abort on mismatch.

5. Use the board image on the root About page and /people/. Set image_alt to KiCad PCB layout for an RF/microwave main board.
6. Deterministically generate the 1200×630 social card:

   convert assets/img/kicad_main_board.png \
   -auto-orient \
   -resize '1200x630^' \
   -gravity center \
   -extent 1200x630 \
   -strip \
   -define png:exclude-chunk=time,date \
   assets/img/og-kicad-main-board.png

7. Set \_config.yml og_image to /assets/img/og-kicad-main-board.png.
8. Retain but explicitly exclude these tracked source files from \_site:
   • assets/img/.prof_pic_einstein_old.jpg
   • assets/img/prof_pic.jpg
   • assets/img/prof_pic_color.png
   • assets/img/prof_pic_color_old.png

9. Remove every textual prof_pic reference, including references in excluded example/about content. The files may remain visible in Git history and raw repository views.
10. Keep \_pages, \_scripts, and .well-known in the Jekyll include policy.
11. Add security.txt with:
    • Contact: private advisory URL.
    • Contact: mailto:Steven.Placzek@ieee.org.
    • Expires: 2027-11-02T23:59:59Z.
    • Preferred-Languages: en.
    • Canonical: https://spkhz.github.io/.well-known/security.txt.
    • Policy: https://github.com/SPkHz/SPkHz.github.io/security/policy.

Verification

• sha256sum confirms the source image before copying.
• identify reports exactly 1200×630 for the social image.
• Unit tests cover valid output, every forbidden artifact class, and deterministic sorted diagnostics.
• A Jekyll build contains the board image, social card, security.txt, and assets/js/search-data.js.
• No built file or HTML/CSS/JSON document contains prof_pic or an original portrait filename.
• No \_site/\_scripts/ directory exists.

Commit

security: guard published artifacts and replace portrait

———

### Task 3: Remove the Vulnerable Vendored Automation and Minimize Dependencies

Files

• Modify Gemfile, Gemfile.lock, package.json, and package-lock.json.
• Modify \_config.yml and affected plugin/layout references.
• Create or extend tests/test_dependency_surface.py.
• Delete .github/actions/setup-python/, .github/python-\*, .github/python-wheels/, .github/ci-tools/, tests/tooling/, root Python requirements files, obsolete citation tooling/data, and unused plugin implementations.

Implementation

1. Add failing tests that reject:
   • The vendored setup-python tree and associated fixture manifests.
   • Root Python requirements/lockfiles when no production Python dependencies remain.
   • Removed Jekyll plugin names or citation/download integration references.
   • Non-exact npm dependency versions.

2. Remove the entire vendored .github/actions/setup-python/ tree rather than editing fixture lockfiles. This removes all seven affected manifest paths.
3. Remove the associated unused Python wheel/test infrastructure, requirements.txt, requirements.lock, bin/update_scholar_citations.py, and \_data/citations.yml.
4. Remove unused Jekyll dependencies and implementations:
   • jekyll-jupyter-notebook
   • jekyll-twitter-plugin
   • ostruct
   • External-post integration with feedjira and httparty
   • Third-party download integration with css_parser
   • Google Scholar/InspireHEP citation automation and disabled layout blocks

5. Preserve assets/jupyter/blog.ipynb as static user content, but remove its converter/build integration and assets/js/jupyter_new_tab.js.
6. Retain only active Jekyll functionality: Jekyll Tabs, jemoji, Jekyll TOC, local JSON resume, Scholar bibliography, pagination, image processing, minification, and related-content classification.
7. Retain exact Node dependencies:
   • prettier 3.8.3
   • @shopify/prettier-plugin-liquid 1.10.2
   • purgecss 8.0.0

8. Set packageManager to npm@11.19.1 and engines to Node 24.22.1/npm 11.19.1.
9. Regenerate both lockfiles inside the exact devcontainer toolchain. Preserve unaffected gem pins, platforms, and Git dependency SHAs; do not perform a broad dependency upgrade.
10. Keep npm lifecycle scripts disabled during installation.

Verification

• rg finds no reference to the removed vendored action or deleted plugin/integration names.
• npm ci --ignore-scripts --no-audit --no-fund succeeds.
• BUNDLE*FROZEN=true bundle \_4.0.15* check succeeds.
• Dependency-surface tests pass.
• A clean Jekyll build succeeds.
• Review lockfile diffs to confirm only intentional direct dependencies and their now-unreachable transitive closure changed.

Commit

security: remove vulnerable vendored automation

———

### Task 4: Minimize and Harden the Browser Dependency Surface

Files

• Modify shared script/style includes, JavaScript setup code, PurgeCSS configuration, and relevant layouts.
• Extend tests/test_built_site.py.
• Create tests/test_frontend_supply_chain.py.
• Delete unused integration assets and the unused Distill layout/include surface.

Implementation

1. Add failing fixture tests for:
   • Active http:// or protocol-relative resource URLs.
   • External scripts or stylesheets lacking an exact HTTPS URL, integrity, or crossorigin="anonymous".
   • target="\_blank" without rel="noopener".
   • Removed integrations reappearing in configuration or generated HTML.

2. Retain only browser functionality proven necessary by current content: core UI, MathJax, Bootstrap tables, image comparison/slider support, and tabs.
3. Remove inactive configuration, includes, setup code, and assets for Chart.js, D3, Diff2HTML, ECharts, code-diff highlighting, Leaflet, Lightbox2, Mermaid, PhotoSwipe, Plotly, polyfills, pseudocode, Spotlight, Vega/Vega-Lite/Vega-
   Embed, Venobox, TikZ, typograms, Google Fonts, and analytics.

4. Remove the unused Distill surface, including \_layouts/distill.liquid, \_includes/distill_scripts.liquid, and assets/js/distillpub/, after the existing no-content-use assertion passes.
5. For every retained CDN executable resource:
   • Use an exact versioned HTTPS URL.
   • Compute SHA-384 SRI from the exact retrieved bytes.
   • Add integrity and crossorigin="anonymous".
   • Do not use moving tags, unversioned URLs, runtime download helpers, or silent fallback CDNs.

6. Convert active plain HTTP links to HTTPS where the destination supports it.
7. Add rel="noopener" to every external new-tab link.
8. Run PurgeCSS only against the built \_site; never rewrite source content as part of the production build.

Verification

• The synthetic frontend tests reject each unsafe fixture and accept a fully pinned fixture.
• The production build passes validate_built_site.py.
• No active HTTP, protocol-relative, analytics, external-font, or removed-integration reference remains.
• Retained MathJax/table/slider/tab content still renders in the local production build.
• The root About page and /people/ display the board image with meaningful alt text.

Commit

security: prune unused web dependencies

———

### Task 5: Replace All Repository CI with One Hardened Pages Workflow

Files

• Create .github/workflows/pages.yml.
• Create generated .github/workflows/actions.lock.
• Create tests/test_workflow_security.py.
• Modify .github/dependabot.yml.
• Create or modify .github/CODEOWNERS.
• Delete all legacy tracked workflow files and the schedule-posts.txt stub.
• Delete unused .github/release.yml, .github/stale.yml, and .github/agents/ metadata after confirming no registered GitHub App consumes it.

Pinned action set

Action Reviewed release Full commit SHA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ━━━━━━━━━━━━━━━━━━ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
actions/checkout v7.0.1 3d3c42e5aac5ba805825da76410c181273ba90b1
─────────────────────────────── ────────────────── ──────────────────────────────────────────
actions/setup-node v7.1.0 949feb2413d6458794dcd2491c4babbbce0c15c1
─────────────────────────────── ────────────────── ──────────────────────────────────────────
ruby/setup-ruby v1.336.0 de492cf36cbab201753d720ce4f4e336cd688c94
─────────────────────────────── ────────────────── ──────────────────────────────────────────
actions/configure-pages v6.0.0 45bfe0192ca1faeb007ade9deae92b16b8254a0d
─────────────────────────────── ────────────────── ──────────────────────────────────────────
actions/upload-pages-artifact v5.0.0 fc324d3547104276b827a68afc52ff2a11cc49c9
─────────────────────────────── ────────────────── ──────────────────────────────────────────
actions/deploy-pages v5.0.1 368f82528645a54fb793d4d04e342629a3f51346

Implementation

1. First add failing workflow-security tests asserting:
   • Exactly one tracked workflow.
   • Every external uses: value is one of the approved 40-character SHAs.
   • Top-level permissions: {}.
   • No pull_request_target, secrets, runtime curl, write access to repository contents, direct pushes, or shell interpolation of untrusted event fields.
   • Checkout uses persist-credentials: false.
   • Deployment is impossible on pull requests or non-main refs.
   • Every action is represented in actions.lock.

2. Configure workflow triggers for:
   • pull_request targeting main
   • push to main
   • workflow_dispatch
   • No path filters

3. Add concurrency keyed by workflow/ref with cancellation, plus explicit job timeouts.
4. Define Build and validate with only contents: read and pages: read.
5. Build steps:
   • Checkout without persisted credentials.
   • Set up Node 24.22.1.
   • Install/verify npm 11.19.1, then run locked npm installation.
   • Run npm run format:check.
   • Set up Ruby 3.3.13 and Bundler 4.0.15 with frozen lockfile use.
   • Verify ImageMagick is available.
   • Configure Pages with enablement disabled so the PR job cannot mutate settings.
   • Run all standard-library tests and ShellCheck.
   • Build Jekyll with JEKYLL_ENV=production.
   • Run PurgeCSS.
   • Run both publication validators.
   • Upload only \_site.

6. Define Deploy with only contents: read, pages: write, and id-token: write. Require Build and validate, use the github-pages environment, and gate it with github.event_name != 'pull_request' && github.ref == 'refs/heads/main'.
7. Delete every prior tracked workflow, including Docker/image publication, formatting comments, link checks, citation/TOC mutations, Python security, custom CodeQL, Lighthouse, axe, and legacy deployment.
8. Keep GitHub-managed Dependabot and CodeQL out of the repository workflow tree.
9. Configure Dependabot only for root Bundler, root npm, and GitHub Actions, weekly with grouped updates and no auto-merge.
10. Add @SPkHz ownership for workflows, actions.lock, dependency manifests/lockfiles, the devcontainer, and security policy files.
11. Install official github/gh-actions-lock pinned to v0.4.0. For Linux amd64, verify the release asset SHA-256 f9da98f2a6e9e0ae77deadf9a2319a8a86bb002b541cc3203b247cc59fb04842, run gh actions-lock, and never edit the generated
    lockfile manually.

Verification

• actionlint reports no findings.
• python3 -B -m unittest tests.test_workflow_security -v passes.
• gh actions-lock rerun produces no diff.
• rg 'uses:' .github/workflows shows only the six approved full SHAs.
• There is exactly one tracked YAML workflow.
• A local simulation or PR run proves that pull requests build but never deploy.
• The required status context appears exactly as Build and validate.

Commit

ci: replace legacy workflows with Pages deployment

———

### Task 6: Replace Stale Documentation with Operational Security Guidance

Files

• Modify README.md, .github/ACTIONS_SECURITY.md, and .github/DEPENDENCY_POLICY.md.
• Create SECURITY.md.
• Modify .gitleaks.toml comments only if needed to explain historical allowlists.
• Delete stale generic installation/customization/FAQ/contribution documents that no longer describe this repository.

Implementation

1. Document only the supported Jekyll workflow, rootless Podman devcontainer, local build/validation commands, GitHub Pages deployment path, dependency update procedure, and rollback process.
2. Document that workflow dependencies are full-SHA pinned and covered by a generated actions.lock; version comments are informational, while the SHA and lockfile are authoritative.
3. State that action upgrades require:
   • An official release review.
   • Full-SHA update.
   • Regenerated lockfile.
   • Workflow-security tests and actionlint.

4. Document the dependency-minimization policy, exact lockfiles, disabled npm lifecycle scripts, and no unreviewed automatic merge.
5. In SECURITY.md, direct reports to private vulnerability reporting first and provide Steven.Placzek@ieee.org as the fallback contact.
6. Exclude SECURITY.md from the built site while continuing to publish .well-known/security.txt.
7. Link upstream theme documentation instead of retaining generic copied guides.
8. Explain that the original portraits remain in Git history/source but are intentionally excluded from the website.

Verification

• Every documented command matches the implemented scripts and versions.
• No documentation refers to Docker publishing, Heroku deployment, Deno deployment, the old workflows, or removed dependencies.
• Security URLs and contact information agree between SECURITY.md and security.txt.
• git diff --check passes.

Commit

docs: document site security and deployment

———

### Task 7: Run Full Reproducible Verification and Open the PR

Implementation

1. Rebuild the devcontainer from its lockfile and run:

   npm ci --ignore-scripts --no-audit --no-fund
   npm run format:check
   BUNDLE*FROZEN=true bundle \_4.0.15* check
   python3 -B -m unittest discover -s tests -p 'test*\*.py' -v
   JEKYLL_ENV=production bundle \_4.0.15* exec jekyll build --trace
   npm run css:purge
   python3 -B scripts/validate_public_artifacts.py \_site
   python3 -B scripts/validate_built_site.py \_site
   actionlint
   git ls-files -z '\*.sh' | xargs -0 -r shellcheck
   git diff --check

2. Run current-tree and history secret scans with redaction using .gitleaks.toml. If a real credential is found, stop, revoke/rotate it, and obtain explicit authorization before rewriting history.
3. Run the network-free dragsec repository scan:

   ~/.venv/bin/dragsec repo scan --path . --format json

   Report only scan shape/counts and remediation categories; never copy host dependency evidence into the plan, PR, or chat.

4. Regenerate both workflow and devcontainer lockfiles and prove no diff.
5. Confirm the branch contains only intended files and every commit is signed.
6. Obtain explicit push/PR authority, push the branch, and open a PR without generated footers.
7. Treat the GitHub-hosted Build and validate run as authoritative when local host tooling differs.
8. Do not proceed to repository cutover until the PR is green and its artifact passes manual spot checks.

Acceptance checks before cutover

• Root About page and /people/ show the KiCad board.
• Social metadata points to a 1200×630 image.
• Original portrait URLs are absent from \_site.
• Search data and security.txt are present.
• No source-only, development, secret, Docker, or \_scripts material is in the Pages artifact.
• No test, linter, validator, lockfile, gitleaks, or dragsec blocker remains.

———

### Task 8: Harden GitHub Settings, Merge, Deploy, and Close Alerts

Implementation sequence

1. Re-capture existing settings immediately before changes and retain the responses only in a temporary local rollback directory.
2. Configure Actions to allow GitHub-owned actions plus ruby/setup-ruby@\*, require full-length action SHAs and workflow lockfile use, use read-only default workflow tokens, and prevent Actions from creating or approving pull
   requests.

3. After confirming there are no remaining references, delete stale repository secrets named:
   • DOCKER_USERNAME
   • DOCKER_PASSWORD
   • LIGHTHOUSE_BADGER_TOKEN
   • PAT

4. Remove variables, deploy keys, webhooks, or self-hosted runner registrations only when they are demonstrably dedicated to the removed Docker, Lighthouse, citation, or legacy deployment paths. Report unrelated unknown integrations
   instead of guessing.

5. Disable Automatic Dependency Submission. Keep the dependency graph, Dependabot alerts, security updates, and version updates.
6. Enable GitHub-managed CodeQL default setup, secret scanning, push protection, and private vulnerability reporting. Do not recreate a tracked CodeQL workflow.
7. Restrict the github-pages environment to deployments from main only and ensure it contains no secrets.
8. Once Build and validate exists on the PR, create a main ruleset requiring:
   • Changes through pull requests.
   • Zero approvals.
   • Build and validate, up to date with main.
   • Resolved conversations.
   • Signed commits.
   • No force pushes or branch deletion.
   • Squash merge only.
   • No routine bypass actors.
   • Automatic source-branch deletion after merge.

9. Set Pages to GitHub Actions, retain HTTPS enforcement, and keep the GitHub-provided domain with no CNAME.
10. Squash-merge the green PR. Let the push trigger the first deployment; use manual dispatch only if the push run did not start.
11. Verify the live site over HTTPS, including About, /people/, the social image, search data, and security.txt.
12. Refresh the dependency graph and inspect all seven alerts:
    • Expected result: alerts close because the manifest paths were removed.
    • If an alert persists against a path that no longer exists, dismiss it only as inaccurate, attaching the removed path and merge SHA as evidence.
    • If any retained manifest still contains an affected package, update to at least future 0.18.3 or setuptools 84.1.0 and repeat the PR workflow; do not dismiss it.

13. Confirm that only the managed Dependabot/CodeQL workflows and the tracked Pages workflow remain active.

Rollback

• Do not delete gh-pages, Deno, or old branch refs.
• If the PR build fails, do not merge or change Pages source.
• If cutover or deployment fails, restore the recorded Pages and environment settings and revert the remediation through a new PR.
• The prior legacy Pages state was already errored, so restoring it is a configuration rollback, not a guaranteed healthy deployment.
• Treat the old gh-pages ref only as preserved evidence unless it is separately validated and explicitly authorized for publication.

———

### Task 9: Perform Heroku Verification Without Mutating Heroku

Implementation

1. Check whether Heroku CLI authentication is available. If not, have the user authenticate out of band; never accept or display the credential.
2. Read-only inventory:
   • Apps and ownership.
   • Pipelines and stages.
   • Review-app configuration.
   • GitHub repository connections.
   • Automatic deploy branches.
   • Config key names, buildpacks, domains, and collaborators without revealing config values.

3. Compare every coupling with SPkHz/SPkHz.github.io and the removed deployment files.
4. Record one of:
   • NO_HEROKU_COUPLING_FOUND, with the evidence queried.
   • EFFECTIVE_STATE_NOT_PROBED if authentication or access is unavailable.
   • A report of exact apps/pipelines/connections that appear obsolete and the impact of disabling them.

5. Do not disconnect GitHub, disable automatic deploys, delete pipelines/apps, or alter Heroku configuration under this plan. The approved Heroku scope is verification-only.

## Final Acceptance Matrix

Area Required result
━━━━━━━━━━━━━━━━━━━━━ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Dependabot All seven vendored-fixture alerts closed or individually dismissed as inaccurate with path/SHA evidence; no affected retained manifest
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Privacy No built portrait or prof_pic reference; board image on / and /people/; originals remain only in source/history
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Pages One successful official Pages Actions deployment to https://spkhz.github.io/; no CNAME
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Actions One tracked workflow, six reviewed full-SHA actions, generated lockfile, least-privilege job tokens
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
CI reduction Docker, image publishing, mutation/comment workflows, citation automation, custom CodeQL, Lighthouse, and unused checks removed
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Browser security No mixed content; retained third-party executable resources are versioned, HTTPS, SRI-protected, and cross-origin annotated
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Repository security Main ruleset, signed PR-only changes, required check, read-only workflow token, secret scanning/push protection/private reporting
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Reproducibility Locked devcontainer works with rootless Podman and exact Ruby/Node/npm/Bundler versions
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Static publication Validators reject unsafe symlinks, special files, empty output, private/dev artifacts, unsafe HTML, and portrait leakage
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Heroku Read-only state recorded honestly; no Heroku mutation
───────────────────── ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Quality gates Unit tests, production build, Prettier, actionlint, ShellCheck, gitleaks, dragsec, and lockfile idempotence all pass

## Assumptions and Fixed Defaults

• The only public domain is spkhz.github.io; no custom domain or CNAME will be added.
• The original portrait binaries remain in Git source/history but are excluded from every Pages artifact.
• Rootless Podman runs on Linux amd64. A different architecture requires an official architecture-specific image digest and a reviewed plan update.
• Exact action releases and SHAs above were verified on 2026-11-02; they must not be silently replaced with newer tags.
• GitHub-generated Dependabot and CodeQL workflows are exempt from the tracked-workflow pinning test because the repository contains no editable uses: references for them.
• No Heroku state will be changed.
• No Deno, gh-pages, or historical branch will be deleted.
• The repository may change before implementation; newer main changes must be audited and incorporated rather than overwritten.
• No PAT is needed for planning. Authenticated implementation should use the narrowest available GitHub credential and must never expose its value.
