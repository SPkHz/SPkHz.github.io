# Local development

Use Linux amd64 with rootless Podman. In your user-level VS Code settings, set
`dev.containers.dockerPath` to `podman`, then reopen this checkout in its container.
The official Dev Containers CLI can also open it:

```sh
devcontainer up --workspace-folder . --docker-path podman --frozen-lockfile
```

The image and feature lockfile pin the environment. Startup performs frozen
Bundler installation. Generation has no npm installation requirement. Node is
available for explicit quality checks; install the pinned npm/formatter packages
with lifecycle scripts disabled as described in the root README.
Port 4000 is forwarded; start the server explicitly inside the container:

```sh
bundle exec jekyll serve --host 0.0.0.0 --port 4000
```

No persistent host service is needed. Keep host credentials and signing
configuration outside the container.
