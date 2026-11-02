# PR #46 and site polish execution record

Plan: [2026-11-02-pr46-codeql-and-site-polish.md](2026-11-02-pr46-codeql-and-site-polish.md).
Design: [approved design](../specs/2026-11-02-pr46-codeql-and-site-polish.md).

This record is saved before publishing the follow-up PR. Its final remote release
evidence belongs in that PR's description and main run history, so recording
post-merge results does not change an already validated head.

- [x] Establish isolated repair worktree and signed merge of current main.
- [x] Repair dependency contract and apply reviewed formatting; pass local gates.
- [x] Establish matching managed CodeQL and PR build evidence.
- [x] Resolve review, merge PR #46 and verify main deployment and analyses.
- [x] Implement and verify approved content and presentation improvements.
- [x] Reconcile every leftover in NEXT_PLAN.md for the final content commit.
- [ ] Review, merge and verify the follow-up release.

## Starting evidence

Fresh main is `81957f25701731d0b311bb5f4b51241b801d3f69` and the original
Dependabot head is `375c08968da3f90370cc18d36c018389017368a8`. Signed merge
`df6be1ee559b005ba66678d34fbe69950aac6f53` preserves both, including PR #47's
template fixes. Primary and prior worktrees are preserved.

The frozen development environment reports Ruby 3.3.13, Bundler 4.0.15,
Node 24.22.1, npm 11.19.1 and working ImageMagick. Startup leaves both lockfiles
unchanged. The pinned Actions lock tool matches its approved checksum.

Reproduced dependency-contract failure: the manifest/lock update retains a test
expecting the previous formatter versions. Two other dependency tests pass.
The existing npm lock diff changes only the formatter/plugin/parser closure,
including removal of the unused parser dependency; Gemfile.lock is unchanged.
Baseline network-free dependency scan: 3 manifests, 38 dependencies, complete,
0 warnings. Scan output is retained only locally; reports contain counts.

## Local repair evidence

- Reproduced the stale dependency assertion and all 18 pre-existing formatter
  differences before editing. Added manifest/root-lock/resolved-version agreement
  and retained exact Node/npm checks. Five deliberate lock/engine drift mutations
  are rejected; all 34 standard-library tests pass in the frozen environment.
- Applied reviewed formatter patches. All 16 changed project documents render
  identical whitespace-normalized Kramdown HTML, including equations and tables.
  The bibliography change is indentation only. Historical remediation-plan
  versions are untouched. New plan commands are fenced to preserve literal text.
- Two independent formatting checks pass. actionlint, warning-free ShellCheck
  and whitespace validation pass. The pinned Actions lock verifier and generator
  report a valid workflow and produce no lock/workflow changes. Frozen container
  startup also preserves its lock; the Ruby lock remains unchanged.
- Redacted current-tree and history secret scans: zero findings in each.
- The first production build generates 2,181 responsive images before computing
  the related-content index. Build cost remains a measured backlog candidate.
- Production builds pass in 483.918 seconds initially and 195.06 seconds with
  generated images retained. The final-source build passes generated-search
  syntax validation, CSS purge and both publication validators. All 208 HTML
  documents match the first build after whitespace and the tabs plugin's random
  UUID are normalized; the generated tab linkage is independently consistent.
  Board alt text, search data, security.txt and the 1200×630 social image pass
  artifact spot checks.
- A fresh read-only repair review found no Critical, Important or Minor defects.
  Remote checks, analysis provenance, merge and deployment remain separate gates.

## PR #46 release evidence

- Repaired head: `5ad9d7e2486ad63f3e1415b1b1cd2c76b21cc6d0`, base
  `81957f25701731d0b311bb5f4b51241b801d3f69`. All three PR commits have valid
  GitHub signature verification; the original bot signature is preserved.
- Managed run [41434987173](https://github.com/SPkHz/SPkHz.github.io/actions/runs/41434987173)
  analyzed `refs/pull/46/head` at that repaired SHA. All categories have zero
  findings, empty error/warning fields and zero SARIF warning/error diagnostics:
  Actions `2076356245`, JavaScript/TypeScript `2076355871`, Python `2076354325`,
  Ruby `2076355194`.
- Proposed merge `0be80a86f8dceb2ad0288dd1520df0e963f991a3` has the recorded
  base/head as parents. Its tree `9aee9a8500cc07540b742429aedec838d9c49720`
  equals the analyzed head and locally calculated merge tree. Direct coverage
  appeared, so no validation PR/branch was needed.
- [PR #46](https://github.com/SPkHz/SPkHz.github.io/pull/46) build
  [41434994279](https://github.com/SPkHz/SPkHz.github.io/actions/runs/41434994279)
  passed; Deploy skipped. The fixed conversation was resolved; strict main
  synchronization, all six checks and zero unresolved threads passed before the
  expected-head-guarded squash merge.
- Merge `9ddd0a6a229503467674880efc028e673ad13620` has a verified GitHub signature
  and exactly the repaired tree. Main Pages run
  [41436601809](https://github.com/SPkHz/SPkHz.github.io/actions/runs/41436601809)
  built and deployed successfully. Matching main analyses are Actions `2076427717`,
  JavaScript/TypeScript `2076435790`, Python `2076428615`, Ruby `2076428356`, all
  clean. Five live HTTPS routes and board/social/search/security artifacts pass;
  nine development/portrait URL probes return 404.

## Follow-up implementation and local evidence

The fresh branch starts at deployed `9ddd0a6`. Implementation commit
`b26ca588cc14e901611b8b9615b7cac0415bbbfd` is SSH-signed. The full suite has
37 tests. New backlog variants first failed in six cases, then passed, with a
positive security.txt fixture. A real PurgeCSS fixture first dropped required
runtime MathJax rules, then passed with a targeted safelist; unused fixture CSS
still gets removed.

The production artifact lists all 55 projects in a nonempty category, preserves
their routes and article HTML, and contains no LinkedIn destination, missing
résumé control, Reddit URL, dropdown output or development material. The two
LinkedIn placeholders remain unpublished YAML comments. Board alt text, social
image dimensions, search generation/syntax and security contact remain protected.

Browser evidence includes 144 rendering cases at 390/768/1440 pixels, both themes,
100%/200% zoom and normal/reduced motion, with zero page overflow, text-contrast,
HTTP or script failures. Changed slider controls were rechecked in 24 cases.
All 24 interaction combinations pass skip navigation, control contrast/focus,
menus, search, cards, tabs/tables, slider arrows/pagination and equations.
Screenshot review additionally required bounding the search-result rows so the
existing ellipsis works; both narrow-theme smoke checks and all 24 targeted search
combinations pass. The targeted harness waits for finite modal opening animations
before measuring settled geometry; no source change was needed for the transient
animation sample. Screenshots remain outside the published artifact. Normal-text and applicable focus/control thresholds
are 4.5:1 and 3:1 respectively.

The verified build costs remain about 523 MiB output, 2,181 cold image conversions,
483.918 seconds cold and about 195 seconds with unchanged image outputs retained.
The same toolchain compiled/purged CSS for intermediate previews. The final
production gate with NEXT_PLAN.md actually present passes all 37 tests, the build
(194.173 seconds), generated-search syntax, CSS purge, both validators and two
formatting checks. The backlog remains absent from the artifact.
Workflow, Ruby, npm and devcontainer locks remain unchanged. actionlint, ShellCheck
and whitespace checks pass. Network-free scan: 3 manifests, 38 dependencies,
complete, zero warnings. Redacted current-tree/history secret checks: zero findings.

NEXT_PLAN.md classifies the approved and archived sources, including newly observed
leftovers: the generated Plotly sample, unused fallback/theme surfaces, expensive
image/indexing work, generated-CSS cache keys, stale internal navigation targets,
old technical markup and security-contact expiry. TODO_NOTES.md is a pointer and
decision summary. Archived sources and other websites' plans remain untouched.

## Execution decisions and limits

Ruling: Use Git for the explicitly located child-repository worktrees because
the exposed managed worktree tool cannot select that repository/path. The cost
if wrong is incomplete harness visibility; Git registration is verified.

Ruling: The repair source review did not certify final artifacts/browser behavior;
those remain independent measured gates. The cost if wrong is a render regression
escaping source inspection.

Ruling: Remote checks, CodeQL provenance, future signatures and deployment remain
independent release gates. The cost if wrong is using stale or unmatched evidence
to merge. PR #46's gates are verified above; the follow-up must meet them too.

Ruling: The later polish receives its own fresh whole-branch review because the
repair review did not cover it. The cost if wrong is missing independent review
of changes introduced by the second delivery.

Ruling: Preserve the existing formatter exclusion for the still-present generated
Plotly demo. The plan assumed it had been deleted, but it remains a generated
upstream bundle with only excluded sample-post references. Its removal/audit is
P1-1 in NEXT_PLAN.md. The cost if wrong is retaining that unused published asset
until the separately scoped dependency/resource audit.

Heroku authenticated state remains `EFFECTIVE_STATE_NOT_PROBED`; no Heroku
mutation is authorized. Memory mode is static evidence only; no memory tool used.

## Final source review and deferred boundaries

A second fresh read-only whole-branch reviewer inspected the complete change,
including the staged backlog and records, and found no Critical, Important or
Minor defects. It independently compared all 55 project article bodies, the
listing, publication links, compiled CSS and unchanged dependency boundaries.
Its independent network-free scan also reports 3 manifests, 38 dependencies,
complete, zero warnings. There are no deferred review minors.

The review's declined judgments are settled as follows, retaining the approved
scope and recording the cost of each decision:

- Ruling: Keep generated Plotly removal deferred to P1-1 as already decided.
  Cost if wrong: the unused generated asset remains published until that audit.
- Ruling: Keep unused theme integrations, Distill styles and CV fallback in P1-1's
  usage audit. Cost if wrong: unnecessary maintenance/runtime surface remains.
- Ruling: Keep artifact, image-processing and LSI optimization in measured P2 work.
  Cost if wrong: oversized output and slow builds persist meanwhile.
- Ruling: Keep the generated-CSS cache-key repair in P2-3. Cost if wrong: clients
  may retain stale CSS under the existing cache behavior.
- Ruling: Keep the legacy latest-posts heading target in P3-2's navigation audit.
  Cost if wrong: that existing link continues to lead to a missing page.
- Ruling: Preserve pre-existing raw TeX and table content until P3-6 compares it
  with authoritative reports. Cost if wrong: existing rendering defects persist.
- Ruling: Keep favicon, keyword, navigation/filter/skills/thumbnail changes in P3.
  Cost if wrong: those existing presentation/content limitations remain.
- Ruling: Keep résumé, biography, PDF, LinkedIn, Search Console, unknown integration
  ownership and authenticated Heroku behind their named content/access inputs.
  Cost if wrong: those features or verifications remain unavailable longer.
- Ruling: Use the executor's complete site-owned archive audit for S4–S6 because
  the reviewer did not independently locate those private sources. Cost if wrong:
  a historical leftover could be omitted despite the recorded reconciliation.
- Ruling: Source review does not certify future signatures, remote checks or live
  deployment. Enforce those independent release gates. Cost if wrong: stale or
  unmatched evidence could permit a defective release.
