# Native HTML/CSS and Reduced Node Dependency — Implementation Plan

## Summary and approved decisions

Goal: Improve the portfolio’s security posture and reduce recurring maintenance while preserving its useful features and engineering content.

Architecture: Keep Jekyll, Liquid, and the existing Ruby Sass compiler. Replace the general-purpose theme foundation with native HTML/CSS and small JavaScript helpers. Generate the published site without Node/npm; retain Node only
for isolated formatting and JavaScript checks.

Execution default: Use superpowers:executing-plans with one implementer and independent review at delivery boundaries.

The approved direction preserves:

• All 55 projects, article routes, technical downloads, equations, tables, tabs, sliders, and bibliography functionality.
• Search and keyboard shortcuts, manual light/dark/system selection, image zoom, sidebar navigation, code copying, and progress/back-to-top controls.
• Existing thumbnails, palette, typography, navigation wording, board imagery, /people/, and publication/privacy protections.
• Frozen dependencies, rootless Podman, protected signed PRs, the generated Actions lock, and GitHub-managed security services.

The measurable targets are:

Area Target
━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Site generation Works with Node/npm unavailable and without node_modules
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
npm dependencies Remove PurgeCSS; approximately 34 → 7 locked package entries at current formatter pins
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Theme foundation Remove Bootstrap 4, MDB, jQuery, Masonry, and obsolete supporting integrations
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Core stylesheet At most 65,536 bytes uncompressed; report widget CSS and fonts separately
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Routine maintenance Grouped updates on the 1st and 15th, 09:00 America/New_York
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Security updates Remain active between routine maintenance windows
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Approved sample retirement Remove the Plotly demonstration and al-folio tutorial video, approximately 30.2 MB combined

This follows the reference site’s preference for native browser capabilities while retaining a proportionate static-site generator. Bootstrap’s official documentation confirms that the installed 4.6.2 foundation is out of support.

## Implementation sequence

### 1. Establish the baseline and deliver the bounded cleanup

☐ At execution, fetch and verify remote main, then create a new worktree directly beneath SPkHz.github.io-worktrees/. Preserve the primary checkout, retained maintenance worktrees, existing refs, and unrelated changes.
☐ Save the approved design and this plan under the repository’s standard docs/superpowers/specs/ and docs/superpowers/plans/ locations. Keep both excluded from publication; retain NEXT_PLAN.md as the canonical backlog.
☐ Capture a fresh production baseline: published routes, technical article content, download destinations and hashes, resource consumers, stylesheet/script sizes, artifact size, and cold/warm build timings. Preserve code blocks,
equations, and table values when comparing rendered content.

☐ Confirm existing interactions before replacing their implementations. In particular, verify sidebar highlighting, bibliography disclosures, image fallbacks, and the absence of configured table sorting/filtering/pagination.
☐ Correct only the About “latest posts” heading link from /blog/ to /articles/.
☐ Remove the approved assets/plotly/demo.html and assets/video/tutorial_al_folio.mp4 files. Remove the obsolete Plotly formatter-ignore entry and add publication regressions preventing either sample from reappearing.

Deliverable: A small cleanup PR with fresh baseline evidence. No other technical downloads or image URLs are retired.

### 2. Replace the theme foundation without removing features

☐ Replace framework layout rules with focused native styles for navigation, content, project/article rows, thumbnails, tables, controls, and sidebar layout. Preserve the current palette and responsive typography.
☐ Convert listings to simple responsive rows with existing thumbnails. Keep homepage sections and entry counts unchanged.
☐ Retain a small compatibility stylesheet for utility classes embedded in technical articles, avoiding broad edits to coursework markup.
☐ Replace the Bootstrap mobile menu with progressive enhancement: navigation remains usable without JavaScript; the enhanced menu retains its toggle, expanded state, keyboard operation, and focus behavior.
☐ Generate sidebar links through the existing Jekyll TOC support. Use a small IntersectionObserver helper for current-section indication.
☐ Replace Bootstrap Table’s present styling role with native tables and local horizontal scrolling. Preserve table content and accessible headers. If baseline testing reveals an interaction absent from the source inventory, preserve
it before retiring the plugin.

☐ Convert shared initializers to DOM APIs. Cover search/menu coordination, theme-dependent tables, image zoom initialization, progress controls, and bibliography disclosures.
☐ Replace the image error handler’s hidden jQuery call with a fallback affecting only the failed image’s own <picture> element.
☐ Remove Bootstrap/MDB, jQuery, Bootstrap-Toc, Bootstrap-Table, Masonry/imagesLoaded, and their obsolete initializers after the replacements pass their feature checks.
☐ Remove unused Distill/CV/typogram imports from the core stylesheet. Emit styles only for the icon glyphs actually used, preserving their existing fonts and licensing.
☐ Retain MathJax, Ninja Keys search, medium-zoom, sliders, and tabs. Scope optional assets to verified consumers using existing page flags where possible. Mathematical content must retain conservative defaults so new technical pages
do not silently lose typesetting.

Interface: Shared navigation exposes window.SiteUI.closeNavigation(): void; the existing search opener uses it instead of Bootstrap’s collapse API. Public page URLs and the search shortcut remain unchanged.

Deliverable: A native site foundation with feature parity. Keep the existing build tools temporarily until this stage passes validation.

### 3. Remove Node from generation and repair asset fingerprinting

☐ Remove PurgeCSS once the focused stylesheet meets its size and rendering requirements. Use Jekyll’s existing compressed Sass output; introduce no replacement CSS optimizer.
☐ Remove both jekyll-terser and jekyll-minifier, then remove only their unreachable lockfile dependencies. Both currently connect the Ruby build to Terser/ExecJS.
☐ Preserve upstream minified vendor distributions. Serve the modest first-party JavaScript and HTML without adding another minification tool.
☐ Retain only Prettier and its Liquid plugin in the npm manifest. Preserve their approved initial versions and exact Node/npm pins; regenerate the lockfile without unrelated upgrades.
☐ Replace the generated-CSS digest implementation in _plugins/cache-bust.rb. Keep the bust_css_cache(path) template interface and calculate SHA-256 keys from final emitted stylesheet bytes.
☐ Add Jekyll::CacheBust.finalize_site_css(site), called by the existing post_write validation hook before publication validation. Resolve generated stylesheet references there, supporting baseurl, repeated builds, and serve/watch
regeneration.

☐ Apply final-byte fingerprinting to all affected local stylesheet references. Preserve their base URLs; leave third-party SRI references intact. Missing files or unresolved fingerprint markers must fail the build.
☐ Harden generated search strings with Liquid JSON serialization and appropriate HTML escaping for fields rendered as HTML by Ninja Keys. Preserve the current search-data URL, result destinations, and behavior.
☐ Remove mandatory npm installation from default development-container startup. Keep pinned Node tooling available for explicit quality checks.
☐ Replace PurgeCSS-specific tests with native stylesheet/runtime tests. The generation test suite must itself run without invoking Node.

Deliverable: A complete production build using Ruby, ImageMagick, and the existing Python validators, with correct stylesheet invalidation.

### 4. Isolate quality checks while preserving deployment protection

Update the existing Pages workflow into three jobs:

Job Responsibility Permissions and gates
━━━━━━━━━━ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
generate Frozen Ruby build, tests, fingerprinting, publication validation, Pages artifact upload contents: read, pages: read; no project Node/npm setup
────────── ───────────────────────────────────────────────────────────────────────────────────────── ──────────────────────────────────────────────────────────────────────────────────
checks Source formatting and JavaScript syntax checks against the exact generated artifact contents: read; retain required check name Build and validate
────────── ───────────────────────────────────────────────────────────────────────────────────────── ──────────────────────────────────────────────────────────────────────────────────
deploy Deploy that same validated artifact Existing main/non-PR condition, github-pages environment, deployment permissions

☐ Make checks depend on generate and run with if: ${{ always() }}. Its first gate must explicitly fail unless generation succeeded, preventing a skipped required job from allowing a merge.
☐ Download only the current run’s named Pages artifact using the official actions/download-artifact action. Resolve its exact reviewed release and regenerate the Actions lock with the repository’s approved tool.
☐ Extract into a temporary directory with path, link, and special-file protections. Treat digest mismatches as failures.
☐ Run formatting with lifecycle scripts disabled during npm installation. Syntax-check generated search JavaScript and the retained first-party scripts without executing generated content.
☐ Make deployment depend on successful generation and checks. Do not rebuild or replace the artifact between checking and deployment.
☐ Preserve empty default permissions, credential-free checkout, hidden security-contact inclusion, and protected deployment settings. Cancel superseded PR runs without interrupting active main deployments.
☐ Update workflow contract tests for the new job graph, action placement, permissions, artifact identity, and failure propagation.

Deliverable: Node remains a quality tool and cannot become an implicit requirement of site generation.

### 5. Reduce recurring maintenance and reconcile the backlog

☐ Configure routine Dependabot updates for each retained ecosystem with interval: cron, cronjob: "0 9 1,15 * *", and timezone: America/New_York.
☐ Keep routine version-update groups separate from applies-to: security-updates groups. Retain vulnerability alerts, security updates, human review, and the prohibition on automatic merging.
☐ Simplify dependency-contract tests to enforce approved dependency names, exact versions, integrity, and agreement among manifests, lockfiles, and toolchain configuration. Avoid redundant version literals that require editing tests
for every otherwise valid update.

☐ Maintain one publication-excluded inventory for retained browser dependencies: upstream source, version, license, checksum/SRI, consumers, and update procedure. Production generation must not fetch executable dependencies.
☐ Record before/after dependency counts, resource requests, core CSS size, artifact size, and build timings.
☐ Reconcile completed portions of P1-1, P2-3, P3-1, and P3-2 in NEXT_PLAN.md. Record the sample reduction under P2-1 without claiming that the broader artifact/image problem is solved.

Deliverable: A documented, twice-monthly routine maintenance process with security updates still handled when warranted.

## Verification and release

For substantial behavior changes, add the relevant failing regression first, implement the replacement, and confirm the regression passes. Use existing validation for the simple link correction.

The five priority regression areas are:

1. Hidden runtime coupling: generation succeeds without Node/npm, and shared interactions no longer require jQuery.
2. CI failure propagation: failed, skipped, or cancelled generation cannot produce a passing required check or a deployment.
3. Final CSS correctness: identical bytes produce stable keys; changed bytes produce changed keys; repeated runs are idempotent; missing files fail.
4. Content and fallback behavior: quoted/Unicode search text remains inert and readable; one failed image does not alter other images; unavailable storage does not break theme selection.
5. Dynamic widget styling: MathJax, search, zoom, tabs, sliders, and sidebar states retain their necessary styles after PurgeCSS removal.

Run the adapted verification sequence in the frozen environment:

• Frozen Bundler checks and the complete standard-library test suite.
• Production generation with Node/npm unavailable.
• Both publication validators, including negative fixtures for private material, portraits, backlog documents, and retired samples, plus the positive security.txt fixture.
• Isolated formatter checks twice and generated-JavaScript syntax checks.
• actionlint, warning-free ShellCheck for tracked shell scripts, whitespace checks, and generated-lock verification/idempotence.
• Redacted secret checks and the supported network-free dependency scan, reporting scan counts only.

Compare the representative pages and widgets at 390, 768, and 1440 pixels, in both themes, at 100% and 200% zoom, with normal and reduced motion. Exercise keyboard navigation and JavaScript-disabled document/navigation fallbacks.
Preserve 4.5:1 normal-text contrast, 3:1 applicable control/focus contrast, and freedom from page overflow or obscured controls.

Release through separately reviewed, signed PRs. Require matching managed CodeQL results, protected merge checks, successful main deployment, and live verification of retained routes and retired-sample 404s. Use a signed revert PR
for regressions.

## Assumptions, boundaries, and research basis

• The approved design is the specification for this plan. Implementation has not begun; no repository files were changed during planning.
• The inspected maintenance tree matches cached origin/main at ffdb124. Execution must verify fresh remote state.
• Node independence applies to project generation, not the internal runtime of GitHub’s JavaScript-based Actions.
• Retained libraries and quality tools still require updates. Reducing dependencies lowers maintenance exposure; the schedule does not postpone relevant security fixes.
• Biography/résumé work, LinkedIn, Search Console, new taxonomy or filters, LSI replacement, and broad image-format/caching changes remain separate backlog work.
• Historical release timings and browser results are baseline evidence, not fresh verification.

Research used the official Exa and Context7 plugins, with retrieved material treated as untrusted evidence. The principal references are the requested design philosophy, Bootstrap’s support status, Jekyll asset handling, GitHub
Actions security guidance, and Dependabot scheduling and grouping.
