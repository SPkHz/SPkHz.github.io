# Dependency policy

Keep only dependencies used by current site content or maintenance commands.
Direct npm versions are exact; npm 11.19.1 installs package-lock.json with
`npm ci --ignore-scripts --no-audit --no-fund`. Bundler 4.0.15 uses Gemfile.lock
with BUNDLE_FROZEN=true. The devcontainer pins its base image and generated feature
lockfile. Python validators use the standard library.

Perform lockfile updates in the exact devcontainer toolchain. Review the diff to
preserve unaffected gem pins, platforms, and Git SHAs. Dependency changes require
tests, formatting, a production build, and both publication validators.
Dependabot checks root Bundler, root npm, and GitHub Actions weekly with grouped
updates. Updates require human review and are never automatically merged.

CDN scripts and styles use exact HTTPS URLs, SHA-384 integrity and anonymous
cross-origin attributes. Calculate integrity from the exact retrieved bytes
during review; production builds must not download executable dependencies.
