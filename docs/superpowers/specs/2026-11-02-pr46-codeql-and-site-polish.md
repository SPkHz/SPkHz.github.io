# PR #46 repair and site polish design

The approved delivery has two stages: repair and merge Dependabot PR #46, then
deliver the small site improvements and a canonical unfinished-work backlog in
a separate pull request. Retain Jekyll, the frozen rootless-Podman devcontainer,
the existing Pages workflow, exact action releases and generated SHA locks,
repository protections, and GitHub-managed security services.

## Dependency repair

Preserve the verified Dependabot commit and merge current main with an SSH-signed
commit. Keep exact Node 24.22.1, npm 11.19.1, Ruby 3.3.13 and Bundler 4.0.15.
Require Prettier 3.9.10, Liquid plugin 1.11.3 and PurgeCSS 8.0.0 consistently in
the manifest, lockfile requirements, resolved direct dependencies and contract
test. Apply and review the new formatter's changes without semantic changes,
preserving historical version statements and unrelated dependency pins.

Managed CodeQL must successfully analyze Actions, JavaScript/TypeScript, Python
and Ruby with no parser diagnostics. If Dependabot exclusion prevents analyses
on PR #46, a maintainer validation PR must use its identical head and a matching
proposed merge tree against the same main commit. Record ref, head, base and
analysis provenance. A neutral exclusion warning is not a parser failure.
Require the build check and skipped PR deployment, resolve the fixed review,
and squash-merge with an expected-head guard. Verify GitHub's signature, main's
deployment and all four main analyses before starting the second stage.

## Content and publication

Preserve routes, navigation wording, technical content and all 55 projects.
Remove the Reddit sentence, active LinkedIn destinations and invitations, broken
résumé PDF controls, and unused featured-project PDF placeholder. Keep LinkedIn
placeholders unpublished; activation requires a finished, polished, approved
résumé and an approved PDF. Preserve the people page, board image and useful alt
text. Move the lone EE 319 lab project into coursework without changing its URL;
render only nonempty category headings and grids. Correct exclusions, remove
stale integration comments and ignore rules, and move inline About tag styles
into scoped existing stylesheets.

Create root NEXT_PLAN.md as the canonical backlog, excluded by Jekyll and the
publication validator. Protect Markdown, generated HTML, text and nested copies
while retaining security.txt. Replace TODO_NOTES.md with a pointer and decision
summary; preserve archived evidence. Classify every relevant historical item,
with source, status, size, priority, evidence, acceptance criteria, next action
and required operator input. Prioritize dependency and executable-resource
reduction, then measured build/publication simplification, then broader design
and content. Keep résumé/biography, approved PDF and LinkedIn, Search Console,
unknown integration ownership and optional authenticated Heroku checks blocked
on the necessary content or access. Supersede portrait restoration, analytics,
comments and obsolete deployment proposals.

## Presentation

Use a system-font body stack, 1rem, weight 400, existing 70ch prose width and
1.625 paragraph line height. Reuse existing theme tokens:

| Purpose                              | Light   | Dark    |
| ------------------------------------ | ------- | ------- |
| Accent/link                          | #1f4e79 | #8db4d8 |
| Hover/visited prose link             | #163a5d | #a9c9e5 |
| Muted text                           | #595959 | #a6a6a6 |
| Foreground on filled accent controls | #ffffff | #1c1c1d |

Derive RGB tokens from the accent. Preserve underlines, non-color navigation
indicators, responsive headings, visible keyboard focus, MathJax, search,
tables, sliders and tabs. Remove card lift, image zoom and large hover shadows;
retain border/color feedback. Respect reduced motion on touched transitions
without overriding functional navigation/slider transforms. Add no dependency,
font, CDN or framework.

## Verification and release

Both stages require frozen installs, two clean formatting checks, standard-library
tests, production build, generated-search syntax check, CSS purge, publication
validators, actionlint, warning-free ShellCheck, whitespace checks, unchanged
regenerated Actions/devcontainer locks, redacted secret checks and network-free
dependency scan counts. Inspect the board, social image dimensions, search and
security.txt; exclude portraits and development/backlog material.

Compare production rendering before/after at 390, 768 and 1440 pixels in both
themes, including 200% zoom and reduced motion. Exercise keyboard navigation,
skip link, menus, search, tabs and technical pages. Require 4.5:1 normal-text
contrast and 3:1 applicable focus/control contrast, with no overflow, clipped
controls, obscured focus or changed equations. Store screenshots outside the
published artifact. Both PRs require signed local commits, matching managed
CodeQL evidence, protected squash merges and successful post-deployment checks.
Finish the backlog after local verification as the last content commit.

Heroku stays read-only; unavailable authenticated state remains
EFFECTIVE_STATE_NOT_PROBED. Preserve all unrelated checkouts, worktrees, branches
and local overrides. Use apply_patch for text edits and no attribution trailers.
