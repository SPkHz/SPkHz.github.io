#!/usr/bin/env python3
"""Fail closed if a public payload contains development material or unsafe links.

Standard library only. Inspect names and link targets, never file contents.
Pass public document roots, not application source or a runtime package root.
"""
import argparse
import os
from pathlib import Path
import stat
import sys

FORBIDDEN_PARTS = {
    '.agents', '.claude', '.codex', '.git', '.github', '.vscode', '.idea',
    '.devcontainer', '.superpowers', '.kicad-mcp', '.playwright-cli', '.bundle',
    '.jekyll-cache', '.ruby-lsp', '.aws', '.local', '_local', '__pycache__',
    'node_modules', 'vendor', 'secrets', 'gmlca', 'mlca', 'lca', 'lpa',
    'session-transcripts', 'session-bootstraps', 'steering', 'handoffs',
    'progress-assessments',
}
ROOT_DEVELOPMENT = {'docs', 'tests', 'scripts', '_scripts', 'site', 'config',
                    'plans', 'reports', 'lighthouse_results', 'output', 'bin'}
FORBIDDEN_NAMES = {
    'readme', 'human_readme', 'agents', 'claude', 'faq', 'skill', 'skills',
    'session-management', 'private-system-notes', 'agent-components.lock',
    'agent-memory', 'contributing', 'customize', 'install', 'security',
    'todo', 'todo_notes', 'development', 'old_readme', 'podman_setup',
    'claude_integration', 'readme_claude_code_repo', 'migration_checklist',
    'production_security_checklist', 'old_production_security_checklist',
    'gh_actions_remediation_todo',
}
BUILD_FILES = {
    'package.json', 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml',
    'deno.json', 'deno.jsonc', 'deno.lock', 'gemfile', 'gemfile.lock',
    'procfile', 'dockerfile', 'containerfile', 'static.json', 'app.json',
    'requirements.txt', 'tsconfig.json', 'next-env.d.ts', 'next.config.js',
    'postcss.config.js', 'tailwind.config.js', 'purgecss.config.js',
    'lighthouserc.json', '.mcp.json', 'codex.resume', 'livereload_log.txt',
    'firebase.json', 'firebase.rules', 'firestore.rules', 'firestore.indexes.json',
}


def forbidden(relative):
    if relative.as_posix() == '.well-known/security.txt':
        return False
    if relative.parts[0].lower() in ROOT_DEVELOPMENT:
        return True
    for part in relative.parts:
        name = part.lower()
        stem = name.rsplit('.', 1)[0] if '.' in name else name
        guidance = stem in FORBIDDEN_NAMES and Path(name).suffix in {'.md', '.markdown', '.html', '.txt'}
        if name in FORBIDDEN_PARTS or name in BUILD_FILES or guidance or name in FORBIDDEN_NAMES:
            return True
        if name.startswith(('.env', '.sops', '.prettier', '.pre-commit', '.markdownlint',
                            '.dockerignore', '.containerignore', '.slugignore', '.gitignore',
                            '.gitattributes', '.all-contributors', '.firebaserc', '_config',
                            'docker-compose', 'podman-compose')):
            return True
        if name.endswith(('.env', '.code-workspace', '.pyc', '.toml')):
            return True
    return len(relative.parts) == 1 and relative.suffix.lower() in {'.md', '.markdown', '.py', '.sh', '.rb', '.ts'}


def validate(directory):
    supplied = Path(directory)
    if supplied.is_symlink() or not supplied.is_dir():
        return ['output must be an existing directory, not a symlink']
    root = supplied.resolve()
    failures = []
    files = 0

    def walk_error(_error):
        failures.append('unreadable output directory')

    for parent, directories, names in os.walk(root, followlinks=False, onerror=walk_error):
        for name in directories + names:
            path = Path(parent) / name
            relative = path.relative_to(root)
            if forbidden(relative):
                failures.append(f'forbidden development material: {relative.as_posix()}')
            try:
                mode = path.lstat().st_mode
                if stat.S_ISLNK(mode):
                    target = path.resolve(strict=True)
                    if not target.is_relative_to(root) or target in path.parents or forbidden(target.relative_to(root)):
                        failures.append(f'unsafe symlink: {relative.as_posix()}')
                elif stat.S_ISREG(mode):
                    files += 1
                elif not stat.S_ISDIR(mode):
                    failures.append(f'non-public special file: {relative.as_posix()}')
            except (OSError, RuntimeError):
                failures.append(f'unreadable, dangling or cyclic entry: {relative.as_posix()}')
    if files == 0:
        failures.append('output has no regular public files')
    return sorted(set(failures))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directories', nargs='+')
    args = parser.parse_args()
    failed = False
    for index, directory in enumerate(args.directories, 1):
        failures = validate(directory)
        if failures:
            failed = True
            print(f'FAIL public payload {index}: {len(failures)} violation(s)', file=sys.stderr)
            for failure in failures:
                print('  ' + failure, file=sys.stderr)
        else:
            print(f'PASS public payload {index}: no development material or escaping symlinks')
    return 1 if failed else 0


if __name__ == '__main__':
    raise SystemExit(main())
