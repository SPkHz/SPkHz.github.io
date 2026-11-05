# SPkHz.github.io

Jekyll source for https://spkhz.github.io/. GitHub Pages publishes only the
validated `_site` artifact from the Pages workflow.

## Development

Use the [rootless Podman devcontainer](.devcontainer/README.md) on Linux amd64.
The project uses Ruby 3.3.13, Bundler 4.0.15, Node 24.22.1 and npm 11.19.1.
The default container startup installs the frozen Ruby dependencies only. Site
generation and its standard-library tests do not require Node/npm or node_modules:

```sh
BUNDLE_FROZEN=true bundle _4.0.15_ check
python3 -B -m unittest discover -s tests -p 'test_*.py' -v
JEKYLL_ENV=production bundle _4.0.15_ exec jekyll build --trace
python3 -B scripts/validate_public_artifacts.py _site
python3 -B scripts/validate_built_site.py _site
```

Install the pinned Node quality tools explicitly when checking formatting and
JavaScript syntax. Installation scripts stay disabled:

```sh
npm install --global npm@11.19.1 --ignore-scripts --no-audit --no-fund
npm ci --ignore-scripts --no-audit --no-fund
npm run format:check
npm run js:check -- _site
```

The core Sass output is compressed by the existing Ruby compiler, with a 65,536
byte budget and no CSS optimizer. A post-write hook fingerprints every local
stylesheet reference from its final SHA-256 bytes before publication validation.

Run `bundle exec jekyll serve --host 0.0.0.0 --port 4000` explicitly for a local
preview. The container forwards port 4000 without starting a server.

## Deployment and updates

Pages has three jobs: `generate` builds and validates without project Node setup,
`checks` runs formatting and syntax checks against that same downloaded artifact,
and `deploy` publishes it only after both succeed on main. The required check
remains **Build and validate**; it runs even when generation fails and explicitly
rejects failed, cancelled or skipped generation. Artifact digest mismatches fail,
and extraction rejects unsafe paths, links and special files. Main deployments
are not cancelled by newer runs; superseded PR runs are cancelled.

Review dependency changes through pull requests; retain exact direct versions,
locked transitive dependencies, and disabled npm installation scripts. Regenerate
Ruby and npm locks in the container without broad upgrades. Never automatically
merge dependency updates. See [.github/DEPENDENCY_POLICY.md](.github/DEPENDENCY_POLICY.md).

Action upgrades require official release review, exact release references,
reviewed full commit SHAs in regenerated `actions.lock`, workflow security tests, and actionlint. See
[.github/ACTIONS_SECURITY.md](.github/ACTIONS_SECURITY.md).

## Publication and security

The About and people pages use the KiCad board image. Original portraits remain
in source and Git history but are excluded from website output and image
conversion. Validators also reject development material, unsafe filesystem
entries, portrait references, mixed content, and unprotected executable CDN
resources. The search template is `_scripts/search-data.liquid`; its permalink
produces `/assets/js/search-data.js`, which is syntax-checked before publication.
Keep Liquid templates distinct from JavaScript sources so CodeQL can parse the
actual JavaScript without encountering Jekyll front matter.
Security contact information is published at
[/.well-known/security.txt](https://spkhz.github.io/.well-known/security.txt).
Report vulnerabilities as described in [SECURITY.md](SECURITY.md).

## Rollback

If a PR fails, do not merge it or change the Pages source. After a failed cutover,
restore the captured Pages/environment settings and revert the change through a
new signed PR. The former publishing configuration was already errored, so
restoring it does not guarantee a working deployment. Preserve historical branch
refs; publish a historical artifact only after separate validation.

The native HTML/CSS foundation retains technical tables, MathJax, search, image
zoom, tabs and sliders. See [the browser dependency inventory](docs/browser-dependencies.md)
for exact distributions, licenses, checksums, consumers and update procedures.
Routine grouped updates run on the 1st and 15th at 09:00 America/New_York;
security updates remain active between those windows. `NEXT_PLAN.md` is the
canonical remaining-work backlog.

The optional browser regressions use an independently provisioned Playwright
installation and a local preview (they are separate from Node-free generation):

```sh
PLAYWRIGHT_MODULE=/path/to/playwright/index.mjs node tests/browser/runtime.mjs http://127.0.0.1:4000
```

## Local responsive-image cache

Responsive variants are cached under `.jekyll-cache/responsive-images-v1`, independently
of the output directory. Entries bind source bytes/path, conversion settings,
publication exclusions, generator/adapter code, Ruby lock and ImageMagick identity.
Verified hits retain the existing converter's names, bytes and static-file registration.
Missing, corrupt or incompatible entries regenerate; excluded files never reach lookup.
The cache is disposable and must not be published or treated as a release artifact.
A full Jekyll clean can remove it. `SPKGHIO_IMAGE_CACHE=off` bypasses caching and uses upstream conversion with the safety/error checks retained;
use a new empty destination when validating that fallback. No CI cache transport is
configured. The cache is local trusted build data, not a signature or a substitute
for publication validation. Production generation remains Node-free and offline.

Coder modules, codec libraries and conversion configuration participate in identity.
If identity tooling is unavailable or a format is unsupported by the identity helper,
generation bypasses the optional cache automatically. Failed conversion commands
fail generation before output can enter the cache.
