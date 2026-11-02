# PR #46 and site polish execution record

Plan: [2026-11-02-pr46-codeql-and-site-polish.md](2026-11-02-pr46-codeql-and-site-polish.md).
Design: [approved design](../specs/2026-11-02-pr46-codeql-and-site-polish.md).

- [x] Establish isolated repair worktree and signed merge of current main.
- [ ] Repair dependency contract and apply reviewed formatting; pass local gates.
- [ ] Establish matching managed CodeQL and PR build evidence.
- [ ] Resolve review, merge PR #46 and verify main deployment and analyses.
- [ ] Implement and verify approved content and presentation improvements.
- [ ] Reconcile every leftover in NEXT_PLAN.md as the final content commit.
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

## Execution decisions

Ruling: Use Git for the explicitly located child-repository worktrees because
the exposed managed worktree tool cannot select that repository/path. The cost
if wrong is incomplete harness visibility; Git registration is verified.

Heroku authenticated state remains `EFFECTIVE_STATE_NOT_PROBED`; no Heroku
mutation is authorized. Memory mode is static evidence only; no memory tool used.
