#!/bin/bash
set -euo pipefail

echo "Entry point script running"

CONFIG_FILE=_config.yml

# Use the reviewed lock without restoring Git state or resolving dependencies.
require_gemfile_lock() {
    if [ ! -f Gemfile.lock ]; then
        echo "ERROR: Gemfile.lock is required; refusing to start Jekyll" >&2
        return 1
    fi
    export BUNDLE_FROZEN=true
}

start_jekyll() {
    require_gemfile_lock || return 1
    bundle exec jekyll serve --watch --port=8080 --host=0.0.0.0 --livereload --verbose --trace --force_polling &
}

start_jekyll

while true; do
    inotifywait -q -e modify,move,create,delete "$CONFIG_FILE"
    echo "Change detected to $CONFIG_FILE, restarting Jekyll"
    while IFS= read -r jekyll_pid; do
        kill -KILL "$jekyll_pid"
    done < <(pgrep -f jekyll || true)
    start_jekyll
done
