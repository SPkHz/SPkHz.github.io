# Reviewed compatibility wheel

Scholarly imports `bibtexparser.bibdatabase` and `bibtexparser.bparser`, which
bibtexparser 2.x removed. Version 1.4.4 remains compatible but has no published
wheel. This directory retains its unmodified official source archive, license,
hash-locked build dependencies and a reproducible wheel.

The source archive SHA-256 is
`093b6c824f7a71d3a748867c4057b71f77c55b8dbc07efc993b781771520d8fb`.
The wheel SHA-256 is
`2310a2541f6b0da8903a5b3354fa1c79742ba6a2e52e1c25ac866f1200b34ca9`.

Use Python 3.13.18 in an isolated build environment. Install build dependencies
from `build-requirements.lock` with `--require-hashes --only-binary=:all:`.
Then disable network access and run `python rebuild.py NEW_OUTPUT_DIRECTORY`.
The script rejects unexpected source bytes and checks the resulting wheel hash.
It retains extracted sources and outputs. Two independent builds produced the
same wheel; no source or installed dependency patch was applied.

The root citation lock selects this directory through a relative `--find-links`
entry. Consumers retain `--require-hashes --only-binary=:all:`; this exception
authorizes no runtime source build. Reassess the finite compatibility wheel when
Scholarly supports a maintained replacement API. Do not update the wheel without
reviewing source, build dependencies, advisory coverage and consumer behavior.
