# Remaining site work

This is the canonical backlog for unfinished work on SPkHz.github.io. The active
TODO_NOTES.md points here; historical plans and archived notes remain evidence,
not competing work queues. This document is excluded from Jekyll publication.
The publication guard also rejects its HTML, text and nested copies.

Keep Jekyll, the frozen rootless-Podman environment, exact dependency contracts,
the existing Pages workflow and generated Actions lock, protected signed PRs,
and GitHub-managed security services. Preserve the public technical content and
required MathJax, search, tables, sliders and tabs. Future work needs its own
scoped implementation and verification; this backlog does not authorize it.

Sizes describe scope: **S** is a bounded edit; **M** spans several files or needs
an evidence-based audit; **L** is a larger refactor or measured optimization.
Priorities follow the approved order below. Blocked items need the named input.

## Sources and evidence

| Source | Record                                                                                                                                                                                                                                                                           |
| ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| S1     | [Original Pages remediation plan](docs/superpowers/plans/2026-11-02-spkhz-pages-security-remediation.md) and [design](docs/superpowers/specs/2026-11-02-spkhz-pages-security-design.md). Historical version statements are preserved.                                            |
| S2     | [PR #46 and site-polish plan](docs/superpowers/plans/2026-11-02-pr46-codeql-and-site-polish.md), [design](docs/superpowers/specs/2026-11-02-pr46-codeql-and-site-polish.md), and [execution record](docs/superpowers/plans/2026-11-02-pr46-codeql-and-site-polish-execution.md). |
| S3     | The former active TODO_NOTES.md, preserved in Git at `9ddd0a6:TODO_NOTES.md`; its title, navigation and palette alternatives are reconciled below.                                                                                                                               |
| S4     | This site's adjacent local `ai-agents/reports/legacy/` archive: `TODO.md` and `TODO_NOTES.md`, including completed checkmarks, open items, commented suggestions and file references.                                                                                            |
| S5     | This site's archived `GH_ACTIONS_REMEDIATION_TODO.md`, recording the obsolete custom-CodeQL version mismatch.                                                                                                                                                                    |
| S6     | This site's archived `PODMAN_SETUP.md`; the current supported instructions are [.devcontainer/README.md](.devcontainer/README.md).                                                                                                                                               |

Only site-owned sources are included. Misfiled plans for other websites are
excluded. Archived checkmarks were checked against current source and artifacts;
an old claim that a résumé or contact button existed is not evidence that it is
ready for publication. PR #46 merged as `9ddd0a6`, with a verified GitHub
signature, a successful Pages deployment and four matching clean main analyses.

## Priority 1 — Security and maintenance

**P1-1 — Audit and reduce theme, runtime, plugin and executable browser dependencies.**
Status: unfinished. Size: L. Sources: S1 dependency/browser contracts; S2 future
priorities; S4 unused-collection and plugin suggestions.

Evidence: the root package surface is intentionally small and locked, but retained
theme integrations, plugins, icon sets, sample data and assets need a usage audit.
The generated `assets/plotly/demo.html` is still tracked and published (4,231,458
source bytes); its only tracked references are in excluded example posts. Its
existing formatter exclusion remains because it is generated upstream material.
Unused Distill styling and the legacy CV fallback also need usage classification.

Next action: map each retained dependency and executable resource to published
content or a maintenance contract. Start with the unused generated Plotly demo,
excluded collections/examples and their support files. Propose explicit removal
targets and native HTML/CSS replacements where practical before deleting them.
Completion: remove approved unused surfaces, reduce executable third-party
resources, preserve required technical features and approved routes, keep exact
locks/SRI, and pass publication, security, browser and managed-CodeQL gates.
Operator input: approve any public-asset or feature retirement and replacement
behavior identified by the audit; no credentials are needed for the local inventory.

**P1-2 — Renew the published security contact before expiry.**
Status: unfinished (future maintenance). Size: S. Source: S1 and
`.well-known/security.txt`, whose current expiry is 2027-11-02.
Next action: confirm the reporting contacts and choose the next approved expiry
before that date. Completion: policy/contact consistency, artifact validation and
live contact checks pass. Operator input: confirmation of the next validity period.

## Priority 2 — Build and publication simplicity

**P2-1 — Reduce artifact and repeated image-processing costs.**
Status: unfinished. Size: L. Sources: S1 build/publication requirements; S2
performance priority; S4 responsive-image and modern-format suggestions.

Evidence: the validated artifact was about 523 MiB; a cold local build generated
2,181 responsive images and took 483.918 seconds. A build retaining those outputs
still took about 195 seconds. Static technical downloads and generated upstream
material contribute to the artifact; not every theme image needs publication.

Next action: measure the largest files and all image consumers, separate required
technical downloads from unused samples, and compare explicit resizing, generation
and caching options. Review AVIF support only if measured benefits justify it.
Completion: report reproducible before/after bytes, conversion counts, timings
and tool versions; preserve approved image/download URLs, alt text, responsive
sizes and layout stability. Operator input: approve any asset retirement or change
to downloadable technical material.

**P2-2 — Measure and simplify related-content indexing.**
Status: unfinished. Size: M. Sources: S2; S1's retained related-content feature.
Evidence: `lsi: true` rebuilds the related-content index even with warm image output.
Next action: isolate its time and memory cost, inventory pages using recommendations,
and compare supported caching, scope reduction or a simpler equivalent.
Completion: publish measured before/after results and preserve useful related links
and content ordering. Operator input: confirm any proposed behavior change before
replacing the current recommendation mechanism.

**P2-3 — Correct generated-asset cache keys.**
Status: unfinished. Size: M. Sources: S2 publication-simplicity priority and
rendered stylesheet evidence. The generated main stylesheet currently receives
the constant empty-content digest in its query string, despite SCSS changes.
Next action: trace the cache-busting filter's input and Jekyll render/write order,
then derive version keys from the actual generated bytes without introducing an
extra runtime dependency. Completion: prove changed CSS gets a changed key,
unchanged CSS keeps a stable key, and all production/artifact checks pass.
Operator input: approve any resulting publication-pipeline change.

## Priority 3 — Broader presentation and content

| Item                                       | Status / size  | Source and evidence                                                                                                                                                                                                                           | Next action and completion criteria                                                                                                                                                                               | Operator input                                                        |
| ------------------------------------------ | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| P3-1: Larger CSS/layout simplification     | Unfinished / L | S2; S4. The restrained token, typography, focus and motion changes are complete; legacy styles and duplicate theme paths remain.                                                                                                              | Inventory used selectors/layouts, propose a smaller native structure, and preserve responsive heading sizes, prose measure, technical widgets, contrast and keyboard behavior at all accepted widths/zoom levels. | Approve the broader design before implementation.                     |
| P3-2: Navigation and search improvements   | Unfinished / M | S2; S3/S4 navigation alternatives. Current wording/routes are preserved and immediate menu/focus/search defects are repaired. The About latest-posts heading still uses the legacy `/blog/` destination while Articles lives at `/articles/`. | Start by reconciling stale internal link targets with existing routes, then review hierarchy and result usefulness. Verify keyboard, mobile, theme and reduced-motion behavior without inventing new routes.      | Confirm audience and any broader navigation/search behavior change.   |
| P3-3: Content-type filters                 | Unfinished / M | S4's open Projects/Coursework/Notes filter proposal; S2. All 55 projects now appear, but no content-type filter is implemented.                                                                                                               | Inventory a truthful taxonomy and design filters that retain an accessible unfiltered list, stable links and all project entries.                                                                                 | Approve categories and behavior.                                      |
| P3-4: Skills presentation                  | Unfinished / M | S4 dedicated-skills proposal; S2. Existing technical tags/tagline remain.                                                                                                                                                                     | Draft a categorized skills section supported by published work and approved résumé facts; avoid invented ratings or proficiency bars.                                                                             | Approve wording and factual claims.                                   |
| P3-5: Approved thumbnails and brand assets | Unfinished / M | S4 thumbnail/favicon proposals; S2 approved-thumbnail priority. Responsive WebP/lazy loading exists, but some project data has blank images and the favicon retains the older accent treatment.                                               | Inventory missing thumbnails and review supplied images plus favicon/palette consistency. Preserve aspect ratios, dimensions, alt text and existing social-card policy.                                           | Supply or approve images and final asset choices.                     |
| P3-6: Technical rendering/content audit    | Unfinished / M | S2's semantic-preservation gate and current project sources. Some pre-existing inline TeX and Markdown pipe tables need review; this cleanup preserves all project article HTML and values.                                                   | Compare affected math/tables with original lab reports, then fix only verified markup and recheck MathJax, tables, sliders and tabs.                                                                              | Resolve ambiguous formulas/values from authoritative source material. |
| P3-7: Metadata keywords                    | Unfinished / S | S4 SEO suggestions; current `_config.yml` retains generic academic/resume terms and omits some suggested technical keywords.                                                                                                                  | Review accuracy after biography/résumé approval, remove misleading terms and add only supported topics. Keep Open Graph/schema behavior and the board social image.                                               | Approve accurate public claims and terms.                             |

## Blocked on approved content or access

| Item                                           | Status / size | Source and current evidence                                                                                                                                                           | Next action / completion criteria                                                                                                                                                        | Required input                                                                                               |
| ---------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| B1: Finish and polish résumé and biography     | Blocked / M   | S2; S4. CV publication remains excluded, current JSON still needs content review, and About/people contain stale student/graduation or template biography/address text.               | Review the JSON and unused CV fallback; finish the intended résumé page and replace template/stale prose with approved public facts. Preserve `/people/`, its board and useful alt text. | Approved current role, graduation details, biography, résumé facts, privacy choices and final page approval. |
| B2: Publish an approved résumé PDF             | Blocked / S   | S2; S4. The referenced PDF is absent; the button and active `cv_pdf` entry are removed.                                                                                               | Obtain the approved accessible PDF, choose its stable path, verify the artifact and restore a download control through a reviewed PR. Do not substitute another project PDF.             | The finished, approved PDF and publication approval.                                                         |
| B3: Enable LinkedIn after résumé approval      | Blocked / S   | S2's explicit publication rule. Both source placeholders remain YAML comments; the username is disabled and rendered HTML/search/structured metadata contain no LinkedIn destination. | After B1 and B2, confirm the approved destination and activate only the agreed static links/metadata. Do not modify the LinkedIn account.                                                | Polished, approved résumé page/PDF and explicit destination/activation approval.                             |
| B4: Search Console verification                | Blocked / S   | S4 SEO proposal; `google_site_verification` remains empty.                                                                                                                            | Use an approved ownership-verification method and verify the resulting public artifact/indexing state. Keep analytics absent.                                                            | Verified site ownership/access and approved verification material, supplied out of band where sensitive.     |
| B5: Resolve integration ownership              | Blocked / M   | S1 settings/integration inventory; S2 carry-forward. Unrelated or unknown integrations must not be removed by inference.                                                              | Reconcile app/webhook/deploy-key/runner ownership with the site inventory; remove only separately authorized obsolete couplings and verify the result.                                   | Owner confirmation, sufficient read access and explicit removal authority for any affected integration.      |
| B6: Optional authenticated Heroku verification | Blocked / S   | S1 task 9; S2. Authenticated state remains `EFFECTIVE_STATE_NOT_PROBED`.                                                                                                              | If requested and access becomes available, perform the read-only inventory and report evidence honestly. No disconnect, deletion, deployment or configuration change is authorized here. | Optional operator request and out-of-band authenticated access.                                              |

## Completed and preserved

These are completed implementation outcomes, not new work. The execution record
and the protected PR/main checks hold the verification evidence. No operator input
is required to keep them; any later change needs its own scope.

| Work                                                          | Status / size / priority | Sources    | Evidence and completion criteria                                                                                                                                                                                                                                                                                 |
| ------------------------------------------------------------- | ------------------------ | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pages/security remediation                                    | Completed / L / done     | S1, S2     | One locked least-privilege Pages workflow; main-only deployment; generated action SHA locks; managed security services and branch protections retained. Obsolete vendored fixture and deployment surfaces remain removed.                                                                                        |
| Reproducible development                                      | Completed / M / done     | S1, S6     | Frozen rootless-Podman startup, immutable image/features and exact Ruby/Bundler/Node/npm contracts pass without lock changes; servers start only explicitly.                                                                                                                                                     |
| PR #46 dependency repair                                      | Completed / M / done     | S2         | Manifest/root-lock/resolved versions and explicit test agree; formatting and rendered technical content verified; review resolved; protected squash merge, verified signatures, deployment and four matching main CodeQL analyses pass.                                                                          |
| Publication/privacy guards                                    | Completed / M / done     | S1, S2     | Board and meaningful alt text on About/people; 1200×630 board social card; generated search and security.txt present; portraits and development/backlog material excluded. Positive security.txt and negative backlog fixtures pass.                                                                             |
| Page headings, title and role/skill tagline                   | Completed / M / done     | S3, S4     | Page-specific H1s and responsive type sizes retained; home shows the name and existing role/tagline. Broader copy changes await approved content.                                                                                                                                                                |
| Current navigation, header icon names and contact destination | Completed / M / done     | S4         | Existing About/Articles/Projects/Code/Contact wording and home link retained; active underline and accessible icon labels preserved. Mobile navigation remains usable at zoom.                                                                                                                                   |
| Palette, body typography, prose links and contrast            | Completed / M / done     | S2, S3, S4 | Approved navy/light-blue, hover, muted and filled-control tokens; derived RGB; system body font, 1rem/400, 70ch prose and 1.625 paragraph leading; visible focus and body underlines.                                                                                                                            |
| Card presentation, spacing and responsive behavior            | Completed / M / done     | S2, S4     | Existing cards, alternating thumbnails, mobile stacking, secondary meta, chips/more tags, featured section and vertical rhythm retained. Lift, zoom and large hover shadows removed from the touched cards; reduced motion respected.                                                                            |
| Keyboard/technical functionality                              | Completed / M / done     | S1, S2, S4 | Skip link, controls, menus, search, cards, tabs, tables, sliders and math verified. Runtime MathJax CSS survives PurgeCSS; narrow screens scroll long equations internally.                                                                                                                                      |
| Responsive imagery and layout stability                       | Completed / M / done     | S1, S4     | Existing responsive sizes/WebP, lazy thumbnails, reserved image dimensions/aspect ratios and decoding behavior preserved. Further generation/AVIF work is P2-1.                                                                                                                                                  |
| Open Graph/schema and copyright                               | Completed / S / done     | S1, S4     | Metadata enabled, board social card retained and copyright/name preserved. Live LinkedIn footer destination removed.                                                                                                                                                                                             |
| Small source/content cleanup                                  | Completed / S / done     | S2, S4     | Reddit sentence removed; placeholders unpublished; missing résumé controls hidden; EE 319 category corrected; all 55 projects present; empty sections suppressed; dropdown typo/publications duplicate fixed; unused PDF data field and genuinely stale ignore entries removed; About tag styles scoped in SCSS. |
| Local résumé JSON and repository showcase data                | Completed / S / done     | S4         | Site-owned JSON and repository data exist; this does not certify the résumé as polished or approved. Content completion remains B1.                                                                                                                                                                              |
| Canonical backlog and archive reconciliation                  | Completed / M / done     | S1–S6      | Active ideas replaced by a pointer/decision summary; relevant historical items classified here; archives preserved and other-site plans excluded.                                                                                                                                                                |

## Superseded historical proposals

No operator action is required for these items. Their earlier rationale remains
in the source records, but they are not pending implementation.

| Proposal                                                                                  | Status / size / priority | Sources | Decision and evidence                                                                                                                                                                                                                   |
| ----------------------------------------------------------------------------------------- | ------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Restore a portrait or portrait Open Graph image                                           | Superseded / S / none    | S1, S4  | Approved privacy policy uses the board; originals remain only in source/history and stay excluded from publication.                                                                                                                     |
| Add analytics                                                                             | Superseded / M / none    | S1, S4  | Analytics integrations were removed under the dependency/privacy reduction. Search Console ownership verification is the separate B4 task.                                                                                              |
| Enable Giscus/comments                                                                    | Superseded / M / none    | S1, S4  | Comment integration and inactive templates were removed; no new feedback service is approved.                                                                                                                                           |
| Restore custom CodeQL/old Actions fixes                                                   | Superseded / M / none    | S1, S5  | The old mixed-action-version failure belongs to a deleted workflow. GitHub-managed four-language analyses now provide the supported evidence.                                                                                           |
| Legacy Docker/image, Heroku, Deno or branch-based deployment workflows                    | Superseded / L / none    | S1, S6  | Jekyll's validated Pages artifact is the sole approved production path. Preserve historical refs; Heroku stays read-only.                                                                                                               |
| Compose, entrypoint auto-start, mutable container setup or persistent development service | Superseded / M / none    | S1, S6  | The immutable frozen devcontainer and explicit preview command replace those archived instructions. No host-shell, service or editor-setting change is part of this work.                                                               |
| Alternative hero/site titles, navigation labels and palette options                       | Superseded / S / none    | S2–S4   | The approved current title/wording and token values control. Broader design work belongs to P3 after approval.                                                                                                                          |
| Immediately fill LinkedIn placeholders or enable more About social UI                     | Superseded / S / none    | S2, S4  | Source placeholders and disabled social identity are deliberate; LinkedIn activation is B3. Additional UI is a future content/navigation decision.                                                                                      |
| Invent/substitute a résumé PDF or populate unused featured-project PDF fields             | Superseded / S / none    | S2, S4  | Missing controls and unused fields are removed; only an approved résumé PDF can satisfy B2.                                                                                                                                             |
| Remove the required people page                                                           | Superseded / S / none    | S2, S4  | `/people/`, its board and alt text are explicitly preserved; its biography cleanup belongs to B1. Books/publications/teaching/dropdown publication exclusions already cover unused template pages; dependency removal still needs P1-1. |
| Enable publication thumbnails as a substitute for project thumbnails                      | Superseded / S / none    | S2, S4  | Publications remain excluded. Approved project imagery belongs to P3-5.                                                                                                                                                                 |

## Acceptance for future deliveries

Use the exact frozen environment and coordinated dependency contracts. Run the
formatter twice, standard-library tests, production build, generated-search syntax
check, CSS purge, both publication validators, actionlint, warning-free ShellCheck,
whitespace checks, lock idempotence, redacted secret checks and network-free
dependency scan counts. Report dependency risk separately from host exposure.

Verify all approved routes/content, board/social/search/security artifacts and
absence of portraits/development material. Compare 390/768/1440-pixel rendering in
both themes, 200% zoom and reduced motion; exercise keyboard navigation and required
technical widgets. Require 4.5:1 normal text and 3:1 applicable focus/control
contrast, without page overflow or obscured controls. Keep screenshots outside
the artifact. Release through signed commits, matching managed CodeQL evidence,
protected guarded squash merge and verified main deployment. Regressions require
a signed revert PR.
