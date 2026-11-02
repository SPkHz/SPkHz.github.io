# SPkHz.github.io

Jekyll source for https://spkhz.github.io/. GitHub Pages publishes only the
validated `_site` artifact from the Pages workflow.

## Development

Use the [rootless Podman devcontainer](.devcontainer/README.md) on Linux amd64.
The project uses Ruby 3.3.13, Bundler 4.0.15, Node 24.22.1 and npm 11.19.1.
Inside the container:

```sh
npm ci --ignore-scripts --no-audit --no-fund
npm run format:check
BUNDLE_FROZEN=true bundle _4.0.15_ check
python3 -B -m unittest discover -s tests -p 'test_*.py' -v
JEKYLL_ENV=production bundle _4.0.15_ exec jekyll build --trace
npm run css:purge
python3 -B scripts/validate_public_artifacts.py _site
python3 -B scripts/validate_built_site.py _site
```

Run `bundle exec jekyll serve --host 0.0.0.0 --port 4000` explicitly for a local
preview. The container forwards port 4000 without starting a server.

## Deployment and updates

Pull requests run **Build and validate**. Only a successful build on main can
deploy through the github-pages environment. The workflow uses the official
Pages actions with separate read-only build and narrowly scoped deployment
permissions. No custom domain is configured.

Review dependency changes through pull requests; retain exact direct versions,
locked transitive dependencies, and disabled npm installation scripts. Regenerate
Ruby and npm locks in the container without broad upgrades. Never automatically
merge dependency updates. See [.github/DEPENDENCY_POLICY.md](.github/DEPENDENCY_POLICY.md).

Action upgrades require official release review, full commit SHA updates,
regenerated `actions.lock`, workflow security tests, and actionlint. See
[.github/ACTIONS_SECURITY.md](.github/ACTIONS_SECURITY.md).

## Publication and security

The About and people pages use the KiCad board image. Original portraits remain
in source and Git history but are excluded from website output and image
conversion. Validators also reject development material, unsafe filesystem
entries, portrait references, mixed content, and unprotected executable CDN
resources. Search source remains a Jekyll input; only generated search data is
published. Security contact information is published at
[/.well-known/security.txt](https://spkhz.github.io/.well-known/security.txt).
Report vulnerabilities as described in [SECURITY.md](SECURITY.md).

## Rollback

If a PR fails, do not merge it or change the Pages source. After a failed cutover,
restore the captured Pages/environment settings and revert the change through a
new signed PR. The former publishing configuration was already errored, so
restoring it does not guarantee a working deployment. Preserve historical branch
refs; publish a historical artifact only after separate validation.

For theme features, consult the [upstream al-folio documentation](https://github.com/alshedivat/al-folio).
