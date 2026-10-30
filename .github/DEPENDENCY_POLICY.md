# Proposed Node dependency selection policy

Status: proposal for owner review. This document does not establish a new
repository-wide requirement until adopted. Existing vulnerability-remediation
requirements remain in force. The Ruby gem policy in `README.md` is separately
adopted and applies to the maintained Gemfile and lockfile.

This policy applies to repository-owned Node runtime, development, build and test
dependencies. Pin direct dependencies to exact stable releases and commit the
package-manager lock, including optional/platform-specific dependencies needed
by supported targets. Install for acceptance without rewriting that lock.

Prefer releases published at least six weeks before selection; use a four-week
minimum preference when the compatible release line makes six weeks impractical.
Age is a supply-chain review preference, not proof that a package is safe. Check
current advisories for the complete resolved tree, including development tools,
nested copies and native optional packages. Record scanner coverage and errors.

A required security fix may be younger than four weeks. Record the release date,
relevant advisory/incident floor, compatibility evidence and reason the older
release cannot satisfy acceptance. Never retain a known affected version merely
to satisfy release age. Unresolved applicability stays open without scanner
suppression. Upgrade dependency owners first, use only reviewed scoped overrides,
and preserve approved major-version boundaries.

Regenerate locks deliberately with the recorded toolchain. Initial resolution
and installation disable automatic lifecycle scripts and installation-triggered
audit/funding requests. Run reviewed audits/builds/tests explicitly with synthetic
data and mocked integrations. No automatic audit-fix, force upgrades or automatic
merge. Existing deployment, CI activation and publication approvals still apply.

GitHub Actions' own Node runtimes and shipped bundles need separate upstream
review; selecting an application's Node version does not update those bundles.
