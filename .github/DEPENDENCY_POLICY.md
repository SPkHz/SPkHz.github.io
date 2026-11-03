# Dependency policy

Keep only dependencies used by current site content or maintenance commands.
Direct npm versions are exact; npm 11.19.1 installs package-lock.json with
`npm ci --ignore-scripts --no-audit --no-fund`. Bundler 4.0.15 uses Gemfile.lock
with BUNDLE_FROZEN=true. The devcontainer pins its base image and generated feature
lockfile. Python validators use the standard library.

Perform lockfile updates in the exact devcontainer toolchain. Review the diff to
preserve unaffected gem pins, platforms, and Git SHAs. Dependency changes require
tests, formatting, a production build, and both publication validators.
Update manifests and regenerate locks together. Dependency-contract tests enforce
approved direct names, exact versions, integrity and agreement with resolved pins
and toolchain configuration; they derive versions from manifests rather than
repeating formatter versions in test constants. Keep Node/npm toolchain pins exact.
Node is reserved for formatting and syntax checks. Production generation uses
Ruby, ImageMagick and standard-library Python, without npm installation or a CSS
optimizer. Removing the Ruby minifiers also removes their ExecJS runtime closure.

Dependabot groups routine version updates for Bundler, npm quality tools and
GitHub Actions on the 1st and 15th at 09:00 America/New_York (`0 9 1,15 * *`).
Separate `applies-to: security-updates` groups do not postpone vulnerability alerts
or security updates until those routine windows. Retain GitHub-managed security
services. Every update requires human review; automatic merging is prohibited.

The single [browser dependency inventory](../docs/browser-dependencies.md)
records upstream sources, versions, licenses, checksums/SRI and verified consumers.
Optional assets follow consumer flags; MathJax keeps a conservative default.

CDN scripts and styles use exact HTTPS URLs, SHA-384 integrity and anonymous
cross-origin attributes. Calculate integrity from the exact retrieved bytes
during review; production builds must not download executable dependencies.
