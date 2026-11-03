#!/usr/bin/env python3
"""Syntax-check first-party sources and the exact Pages artifact; never execute it."""
import argparse
from pathlib import Path
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('artifact', type=Path, nargs='?', default=Path('_site'))
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    generated = args.artifact / 'assets/js/search-data.js'
    if not generated.is_file() or generated.is_symlink():
        parser.error('generated search JavaScript is missing or unsafe')
    sources = sorted(p for p in (root / 'assets/js').glob('*.js') if not p.name.endswith('.min.js'))
    sources += sorted((root / 'tests/browser').glob('*.mjs'))
    for source in [generated, *sources]:
        subprocess.run(['node', '--check', str(source)], check=True)
    print(f'PASS JavaScript syntax: generated search and {len(sources)} source files')


if __name__ == '__main__':
    main()
