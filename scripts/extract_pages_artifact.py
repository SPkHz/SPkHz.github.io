#!/usr/bin/env python3
"""Extract one verified Pages tar safely, preserving exact file bytes."""
import argparse
from pathlib import Path, PurePosixPath
import shutil
import tarfile


def extract(archive, destination):
    if destination.exists() or destination.is_symlink():
        raise ValueError('Unsafe extraction destination: must not exist')
    with tarfile.open(archive, 'r:') as stream:
        members = stream.getmembers()
        paths = {}
        total = 0
        for member in members:
            name = PurePosixPath(member.name)
            if (name.is_absolute() or '..' in name.parts or '\\' in member.name
                    or not (member.isdir() or member.isreg()) or member.issparse()):
                raise ValueError('Unsafe archive member')
            if name == PurePosixPath('.'):
                if not member.isdir():
                    raise ValueError('Unsafe archive root')
                continue
            if name in paths:
                raise ValueError('Unsafe duplicate archive member')
            paths[name] = member
            total += member.size
            if total > 2 * 1024**3:
                raise ValueError('Unsafe archive size: exceeds 2 GiB')
        for name in paths:
            if any(parent in paths and not paths[parent].isdir() for parent in name.parents):
                raise ValueError('Unsafe file/directory collision')
        # Validate the complete archive before creating anything.
        destination.mkdir(parents=True)
        for name, member in paths.items():
            target = destination.joinpath(*name.parts)
            if member.isdir():
                target.mkdir(parents=True, exist_ok=True)
            else:
                target.parent.mkdir(parents=True, exist_ok=True)
                with stream.extractfile(member) as source, target.open('xb') as output:
                    shutil.copyfileobj(source, output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('archive', type=Path)
    parser.add_argument('destination', type=Path)
    args = parser.parse_args()
    try:
        extract(args.archive, args.destination)
    except (OSError, ValueError, tarfile.TarError) as error:
        parser.exit(1, f'{error}\n')


if __name__ == '__main__':
    main()
