"""Rebuild the reviewed wheel with preinstalled, hash-locked build dependencies.

Run in a network-disabled task environment with Python 3.13.18. The supplied
output directory must be new; source and build receipts remain available there.
"""

import hashlib
import os
from pathlib import Path
import subprocess
import sys
import tarfile

root = Path(__file__).resolve().parent
archive = root / "bibtexparser-1.4.4.tar.gz"
expected_source = "093b6c824f7a71d3a748867c4057b71f77c55b8dbc07efc993b781771520d8fb"
expected_wheel = "2310a2541f6b0da8903a5b3354fa1c79742ba6a2e52e1c25ac866f1200b34ca9"
if hashlib.sha256(archive.read_bytes()).hexdigest() != expected_source:
    raise SystemExit("Source archive identity mismatch")
output = Path(sys.argv[1]).resolve()
output.mkdir(parents=True, exist_ok=False)
source = output / "source"
source.mkdir()
with tarfile.open(archive) as bundle:
    for entry in bundle:
        if not (entry.isfile() or entry.isdir()):
            raise SystemExit("Unexpected archive entry")
        target = source / entry.name
        target.resolve().relative_to(source)
        if entry.isdir():
            target.mkdir(parents=True, exist_ok=True)
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(bundle.extractfile(entry).read())
env = os.environ.copy()
env.update(SOURCE_DATE_EPOCH="1735689600", PYTHONHASHSEED="0", PYTHONDONTWRITEBYTECODE="1")
subprocess.run(
    [sys.executable, "-m", "build", "--wheel", "--no-isolation", "--outdir", str(output)],
    cwd=source / "bibtexparser-1.4.4",
    env=env,
    check=True,
)
wheel = output / "bibtexparser-1.4.4-py3-none-any.whl"
if hashlib.sha256(wheel.read_bytes()).hexdigest() != expected_wheel:
    raise SystemExit("Rebuilt wheel identity mismatch")
print("Verified reproducible bibtexparser wheel")
