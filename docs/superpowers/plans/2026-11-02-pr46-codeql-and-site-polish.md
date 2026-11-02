# PR #46 Repair and Site Cleanup Implementation Plan

> Execution: Use superpowers:executing-plans for inline implementation, preserving the previously selected execution method. Track completion with checkboxes.

Goal: Repair and merge PR #46 with verified CodeQL coverage, resolve its review finding, then complete the approved small content and visual improvements and consolidate unfinished work.

Architecture: Retain Jekyll, the locked rootless-Podman devcontainer, the existing Pages workflow, and GitHub-managed CodeQL. Deliver the dependency repair through PR #46, followed by a separate content, presentation, and backlog
PR.

Tech stack: Ruby 3.3.13, Bundler 4.0.15, Node 24.22.1, npm 11.19.1, Prettier 3.9.10, Liquid plugin 1.11.3, PurgeCSS 8.0.0, and standard-library Python tests.

Documentation: During execution, materialize the approved design and this plan under docs/superpowers/specs/ and docs/superpowers/plans/, using the basename 2026-11-02-pr46-codeql-and-site-polish.

Spec: `docs/superpowers/specs/2026-11-02-pr46-codeql-and-site-polish.md`.

The task headings below organize the approved plan for inline execution. After every auto-compaction, re-read this plan, the execution record, and both original local plans (`pr46-implement-site-cleanup-PLAN.md` and `update-gh-pages-PLAN.md`).

Progress snapshot: implementation and local verification precede the follow-up PR. Final protected-merge and live results are maintained in that PR's description and main run history. Direct PR #46 CodeQL coverage made the conditional validation-PR steps unnecessary.

## 1. Constraints and starting evidence

- Re-read the original remediation plan (docs/ai-agents/_local/plans/update-gh-pages-PLAN.md) after every auto-compaction, alongside this plan and its execution record.
- Revalidate remote state before implementation. The researched main commit is 81957f25701731d0b311bb5f4b51241b801d3f69; PR #46 currently points to 375c08968da3f90370cc18d36c018389017368a8.
- Preserve the completed security remediation, including its approved exact action releases backed by generated SHA locks. Keep existing branch protections, deployment restrictions, and managed security services.
- Create new worktrees directly beneath Websites/SPkHz.github.io-worktrees/. Preserve the primary checkout, existing worktrees, Deno branches, and gh-pages.
- SSH-sign every locally authored commit using the existing signing configuration and SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket. Preserve Dependabot’s verified GPG commit. As approved, GitHub’s verified signature is acceptable
  for the final squash merge.

- Use apply_patch for text changes, including reviewed formatter-generated patches. Do not add attribution trailers or generated-tool footers. Never run sudo.
- Keep LinkedIn placeholders in source. Publish no active LinkedIn destination until the résumé page is finished, polished, and approved.
- Heroku remains read-only. Previously unavailable authenticated state remains EFFECTIVE_STATE_NOT_PROBED.

The earlier JavaScript syntax problem is already fixed on main. All four current main CodeQL analyses report no errors or findings. PR #46 has no corresponding analyses; GitHub’s CodeQL maintainers describe default setup’s
intentional Dependabot exclusion. Its neutral warning must not be mistaken for a fresh parser failure.

## 2. Repair, validate, and merge PR #46

### Task 1: Prepare the signed repair branch

- [x] Verify repository roots, worktree registrations, current changes, signing configuration, remote main, and PR head.
- [x] Create worktree pr46-maintenance-20261102 with local branch maintenance/pr46-repair-20261102 from the freshly fetched PR branch.
- [x] Incorporate current main through an SSH-signed merge commit. Preserve the existing Dependabot commit and PR #47’s template fixes. Do not rebase or force-push the bot branch.
- [x] Open the frozen devcontainer and verify the exact toolchain before dependency installation.

### Task 2: Fix the dependency contract and formatting

- [x] Reproduce the dependency-contract failure and the formatter’s reported differences before changing them.
- [x] Update tests/test_dependency_surface.py::test_exact_node_dependencies to require exactly:

  | Dependency                        | Approved version |
  | --------------------------------- | ---------------- |
  | `prettier`                        | `3.9.10`         |
  | `@shopify/prettier-plugin-liquid` | `1.11.3`         |
  | `purgecss`                        | `8.0.0`          |

- [x] Add assertions that the manifest, lockfile root requirements, and resolved direct dependency versions agree. Retain the exact Node/npm contract.
- [x] Review the existing npm lockfile changes. Expected changes include the new Liquid parser and removal of its unused ohm-js dependency. Preserve unrelated pins and the Ruby lockfile.
- [x] Apply Prettier 3.9.10/Liquid 1.11.3 formatting to all 18 reported files and any additional affected files introduced by current main. Do not disable checks or expand ignore rules to conceal failures.
- [x] Inspect the bibliography template, Markdown tables, Liquid expressions, and mathematical content for semantic changes. Preserve historical version statements in the original plan; formatting that document does not authorize
      rewriting its history.

- [x] Update the dependency-maintenance policy to require manifest, lockfile, and explicit contract-test updates together.
- [x] Commit the tested changes with SSH signatures and push normally to dependabot/npm_and_yarn/node-c0c9a05018.

### Task 3: Obtain matching CodeQL evidence

- [x] Inspect fresh checks on the repaired PR. If all four managed analyses appear, use them. Otherwise create a maintainer-authored validation PR from validation/pr46-codeql-20261102, pointing to the identical repaired head commit.
- [x] Require successful managed analyses for /language:actions, /language:javascript-typescript, /language:python, and /language:ruby, without parser diagnostics.
- [x] Record the analyzed ref, commit, and base. Compare the validation PR’s proposed merge tree with PR #46’s proposed merge tree against the same main commit. Refresh validation if either head or main changes.
- [x] Require successful Build and validate and skipped Deploy on PR runs. Do not add a custom CodeQL workflow or weaken repository settings.
- [x] If managed analysis remains unavailable on the maintainer PR, inspect its tool-status and workflow evidence and rerun an available failed analysis. Keep merging blocked if coverage cannot be established; do not substitute
      unrelated or stale scans.

PR #46 may retain GitHub’s intentional neutral warning. The acceptance criterion is successful analysis of matching code, with its provenance recorded.

### Task 4: Resolve the review and merge

- [x] After the pushed contract fix passes focused and full verification, resolve the connector’s review thread, thread ID PRRT_kwDOQ5pzis6ynKd-.
- [x] Verify all introduced commits’ signatures, current required checks, resolved conversations, and strict main synchronization.
- [x] Squash-merge PR #46 using an expected-head-SHA guard and an explicit commit title/body without generated trailers.
- [x] Verify the resulting commit’s GitHub signature, successful main Pages deployment, and all four main CodeQL analyses.
- [x] Close the temporary validation PR without merging it; delete only its temporary branch after recording the evidence.

### Task 5: Complete the approved small site changes

Start branch maintenance/site-polish-20261102 in a fresh site-polish-20261102 worktree from main after PR #46’s successful deployment.

#### Content, links, and publication

- [x] Remove the sentence containing the HTTP Reddit link from _pages/about_steven.md. Preserve /people/, its board image, and meaningful alt text.
- [x] Preserve the LinkedIn placeholders as unpublished comments or data. Hide the About links/buttons, remove the existing live footer link, keep the social username disabled, and remove copy inviting LinkedIn contact.
- [x] Verify that rendered HTML, search data, and structured social metadata contain no active LinkedIn destination. Do not modify any LinkedIn account.
- [x] Hide the missing résumé-PDF button and remove the active cv_pdf entry. Keep résumé completion and later LinkedIn activation deferred; do not invent a résumé or substitute an unrelated PDF.
- [x] Change the lone EE 319 lab project’s category to coursework, preserving its permalink. Render category headings and grids only when they contain projects. Confirm all 55 current projects appear.
- [x] Correct the dropdown exclusion typo and remove the duplicate publications exclusion. Preserve the required people page.
- [x] Remove stale comments and formatter exclusions for deleted citation, vendored setup-python, Distill, Plotly, and Lighthouse paths. Preserve exclusions for current generated sources and embedded upstream LaTeX material.
- [x] Remove the unused featured-project PDF placeholder field rather than inventing a link.
- [x] Move the About page’s inline tag styles into the existing stylesheet, scoped to the affected content.

#### Restrained visual polish

Keep existing layouts, navigation wording, responsive heading sizes, technical content, and required MathJax, search, table, slider, and tab functionality.

- [x] Use a system-font body stack, 1rem size, weight 400, existing 70ch prose width, and 1.625 paragraph line height.
- [x] Reuse the existing theme tokens with these values:

  | Token purpose                        | Light theme | Dark theme |
  | ------------------------------------ | ----------- | ---------- |
  | Accent/link                          | `#1f4e79`   | `#8db4d8`  |
  | Hover/visited prose link             | `#163a5d`   | `#a9c9e5`  |
  | Muted text                           | `#595959`   | `#a6a6a6`  |
  | Foreground on filled accent controls | `#ffffff`   | `#1c1c1d`  |

- [x] Keep RGB token values derived from the corresponding accent colors. Preserve body-link underlines and non-color active-navigation indicators.
- [x] Remove lift, thumbnail zoom, and large hover shadows from post, featured, and latest-post cards. Retain border/color feedback and visible keyboard focus.
- [x] Respect reduced-motion preferences for touched transitions without overriding transforms required by navigation or sliders.
- [x] Introduce no new fonts, CDN resources, dependencies, or frameworks.

Public routes and validator function signatures remain unchanged. The publication policy gains explicit protection for the new backlog document.

## 4. Verification and release gates

Run the following in the locked development environment for each delivery stage:

```sh
npm ci --ignore-scripts --no-audit --no-fund
npm run format:check
BUNDLE_FROZEN=true bundle _4.0.15_ check
python3 -B -m unittest discover -s tests -p 'test_*.py' -v
JEKYLL_ENV=production bundle _4.0.15_ exec jekyll build --trace
node --check _site/assets/js/search-data.js
npm run css:purge
python3 -B scripts/validate_public_artifacts.py _site
python3 -B scripts/validate_built_site.py _site
actionlint
git ls-files -z '*.sh' | xargs -0 -r shellcheck
git diff --check
```

- [x] Confirm a second formatting check passes without additional edits.
- [x] Verify the Actions lock with the pinned lock tool and confirm regeneration produces no change. Confirm frozen devcontainer startup leaves its lockfile unchanged.
- [x] Run redacted current-tree/history secret checks and the network-free dragsec scan. Report only scan counts and remediation categories.
- [x] Add publication-regression fixtures rejecting NEXT_PLAN.md, generated NEXT_PLAN.html, text variants, and nested copies while continuing to allow security.txt.
- [x] Inspect the production artifact for the board image and alt text, 1200×630 social image, search output, and security.txt. Confirm portraits and development material remain absent.
- [x] Verify the Reddit link, LinkedIn destinations, broken résumé controls, excluded dropdown page, empty project sections, and backlog documents are absent from the relevant public output.
- [x] Compare before/after rendering at 390, 768, and 1440 pixels, in light and dark themes, with 200% zoom and reduced motion. Exercise keyboard focus, skip navigation, menus, search, tabs, and representative technical pages.
- [x] Require normal-text contrast of at least 4.5:1 and applicable focus/control contrast of 3:1. Check actual rendered combinations, including muted text and filled controls.
- [x] Verify no page-level horizontal overflow, clipped controls, obscured focus, or altered equations. Store screenshots outside the published artifact.

The follow-up PR must pass the same signed-commit, build, managed-CodeQL, protected squash-merge, and post-deployment checks. Roll back a shipped regression through a signed revert PR.

### Task 6: Reconcile completed work and record every leftover

- [x] Audit the original remediation plan, current site plan/spec, active TODO_NOTES.md, and site-specific archived TODO, Actions-remediation, and Podman documents. Exclude misfiled plans belonging to other websites.
- [x] Create root NEXT_PLAN.md as the canonical unfinished-work backlog. Replace the active competing idea list with a short pointer and decision summary; preserve archived records.
- [x] Add the backlog to Jekyll exclusions and the publication validator’s forbidden-name policy.
- [x] Classify every discovered item as completed, superseded, unfinished, or blocked. Include source, size, priority, evidence, completion criteria, and any required operator input.
- [x] Preserve completed work such as page-specific headings, Open Graph metadata, copyright, skip links, and responsive images. Mark incompatible historical proposals—portrait restoration, analytics, comments, and obsolete deployment
      workflows—as superseded.

- [x] Prioritize remaining medium and large work in this order:

  | Priority                              | Future work                                                                                                                                                                                                    |
  | ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | 1 — Security and maintenance          | Audit and remove unused theme/runtime/plugin dependencies; replace necessary UI with native HTML/CSS where practical; reduce executable third-party resources while preserving technical features.             |
  | 2 — Build and publication simplicity  | Reduce oversized artifacts, repeated image-processing work, and related-content build costs using measured before/after results.                                                                               |
  | 3 — Broader presentation and content  | Larger CSS/layout simplification, navigation/search improvements, content filters, skills presentation, and approved thumbnails.                                                                               |
  | Blocked on approved content or access | Finish and polish the résumé and biography; obtain an approved PDF; enable LinkedIn only afterward; Search Console verification; unresolved integration ownership; optional authenticated Heroku verification. |

- [x] Finalize this backlog after implementation and local verification, as the final content commit of the follow-up PR. Carry every unfinished medium or large task forward with an explicit next action.
- [ ] Complete the protected merge and live verification, then report both merged PRs, signature and scan evidence, deployment results, and the location of the remaining-work backlog.
