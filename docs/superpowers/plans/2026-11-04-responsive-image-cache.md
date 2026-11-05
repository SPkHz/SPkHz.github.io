# Verified responsive-image cache

Session logical/execution identity: `spkhzghio-upd-N01b--MLCA` for both.
Base: cached `6e9e5dabc27828e85f9d5401f705c76a31e28988`.
Operator-approved Option A, executed inline. This record captures local verification;
remote delivery evidence belongs to the protected PR and main deployment runs.

## Plan and ledger

1. Verify registered worktree/common directory and inspect locked generator.
2. Reproduce missing destination-independent reuse, then implement verified caching.
3. Exercise invalidation, publication, unsafe paths, interrupted/concurrent records.
4. Compare fresh production LSI-enabled control, empty-cache generation,
   new-destination hits and retained-destination warm generation.
5. Verify preservation, quality checks and review the diff.

The locked 1.4.0 generator reuses outputs solely when their mtime exceeds source
mtime. It converts and registers outputs in `generate_files`; the adapter wraps
that boundary and retains the original conversion command and output registration. Misses remove
old destination variants before conversion so mtime cannot accept stale bytes.
Hits restore verified bytes and set mtime strictly newer before registration.

Ruling: use a small Ruby standard-library helper and separate focused Python test
file for cache storage/integration coverage; no dependency added.
Ruling: preserve all existing checkouts/artifacts, use a copied fresh source control
inside ignored scratch, and keep LSI enabled in every production measurement.
Initial-boundary ruling: no workers/reviewer agents, commits or release operations;
the then-current scope required an uncommitted review boundary. The later review
and delivery grant below explicitly supersedes that restriction.

The local image lacked locked gems. The operator separately authorized exact
Gemfile.lock downloads; frozen installation completed without lock changes.
Generation runs with networking disabled and the Node installation hidden.

## Invalidation and safety

Keys bind relative source path and SHA-256, edge/format/configuration/exclusions,
Ruby description, locked dependencies, upstream and adapter code, converter binary
hash, version/configure/policy output and relevant conversion environment variables.
An interrupted exploratory build was stopped only after verifying its exact task
command and worktree mount; its cache/output remain as evidence. Accepted cold
measurement starts with a new empty cache after the final review fixes.

Linked shared-library bytes are hashed as well as the converter executable.
Cache records contain bounded metadata and raw output bytes with SHA-256; one
atomic rename commits both. Partial files are never lookup candidates. Unsafe or
unavailable caches fall back to conversion. Output paths must remain within the
destination; symlink inputs/outputs/cache paths are rejected or bypassed.
The cache is trusted local build data; hashes detect corruption, not malicious
rewrites by an actor with the same account's filesystem privileges.

## Initial verification

The original 48-test suite passed before implementation. The new cache regression
first failed because a fresh destination converted again, then passed. Six child
writers and orphaned partial records exercise atomic record handling. A review
regression then reproduced a source-mutation cache-poisoning race; checking the
input digest before committing the record fixed it. The pre-review full suite passed 51 tests, including header-only and FIFO cache records.

Fresh control reproduces 506,944,952 bytes / 3,510 files. The retained preview's
+4,553 bytes localize entirely to related-link items in 41 post HTML files.
Three additional equal-size changes are feed/sitemap timestamps and a generated
Jekyll Tabs UUID. This is fresh comparison evidence, not retroactive verification
of the historical release. No indexing behavior is changed.

The initial boundary used inline self-review. A subsequent operator grant authorized
one independent read-only reviewer and protected delivery.
The implementation preserves the converter command and output registration;
new helper/test files separate storage and regression responsibilities.

Results are recorded in the adjacent JSON, with detailed local logs under
`.jekyll-cache/p2/`. Cold/hit/warm observations are individual runs, not statistical
performance estimates. P2-2 indexing instrumentation, ranking changes, CI transport,
asset retirement remains outside this work. Remote release verification was outside
the initial boundary and is authorized by the later delivery grant.

## Rollback

Set `SPKGHIO_IMAGE_CACHE=off` and generate into a new empty destination to use the
upstream conversion with input/output safety and successful-exit checks retained. Cache data is disposable. Preserve these changes/evidence
for review; do not reset existing worktrees. A future released regression would
require a separately authorized revert/release process.

## Acceptance interpretation

All generated file paths and bytes match the fresh production control except
feed/sitemap build timestamps and the linked generated tab UUID. Comparison
normalizes only those known volatile fields; all image bytes and technical
assets match exactly. Ordered recommendations match on all 41 posts. The 204
ordinary routes, board/social images, privacy exclusions and CSS budget remain
preserved. No browser run is needed for this backend-only change: templates,
image bytes and normalized HTML are unchanged. Browser results in older records
remain historical. No previews or browser processes were started.

Cache storage adds 71,368,645 regular-file bytes for 2,181 records, including
329,331 bytes of metadata over 71,039,314 image bytes. Hits validate and rewrite
variants even in a retained destination, so warm builds still perform image I/O.
No published-artifact reduction or CI acceleration is claimed. Generation keeps
LSI enabled; the remaining warm generation time is not an isolated LSI measure.

Memory figures use Linux RUSAGE_CHILDREN maximum individual child-process RSS,
not the aggregate peak of a container or process tree. Single-run timings are
indicative: the control and parts of cold generation overlapped exploratory
verification work; these are not repeated statistical benchmarks.

## Pre-review measured results

| Run                               | Wall seconds | Jekyll seconds | Conversions | Hits / misses | Max RSS KiB |
| --------------------------------- | -----------: | -------------: | ----------: | ------------- | ----------: |
| control                           |      460.126 |        458.449 |        2181 | n/a / n/a     |      196340 |
| empty cache empty destination     |      488.120 |        486.450 |        2181 | 0 / 2181      |      196260 |
| populated cache empty destination |      187.616 |        185.809 |           0 | 2181 / 0      |      125504 |
| retained destination warm         |      185.919 |        184.179 |           0 | 2181 / 0      |      129212 |

All three candidate states retain 3,510 files / 506,944,952 bytes, matching the
fresh production control. Full suite: 51 PASS; both validators, syntax checks,
formatting twice, warning-free ShellCheck and scoped diff review PASS. Source-only
dependency inventory: 3 manifests / 115 entries, complete, zero warnings.

## Independent review and delivery follow-up

The independently reviewed pre-review source and measurements are preserved above
and in `pre_review_*` JSON fields. Three substantive findings were verified and fixed:
codec modules/dependencies/configuration now participate in identity; unsuccessful
conversion subprocesses cannot populate the cache; unavailable identity tooling
bypasses lookup/storage and forces conversion. Source FIFOs are rejected before
hashing, and destination parents are validated before creating child directories.
Five focused regressions first failed, then all eight cache regressions passed.
The codec regression initially failed because the new identity helper was absent;
it subsequently verifies changed coder bytes alter identity with the converter
unchanged. It is not a claimed reproduction of a codec-only stale-cache hit.

The same independent read-only reviewer examined the fixes and found no remaining
substantive blocker for configured raster formats. Cache-off mode retains the new
safety and successful-exit checks. Final-source production checks and remote release
evidence are recorded separately below/through the PR; older results are not promoted.

## Final reviewed source verification

| Run           | Wall seconds | Jekyll seconds | Conversions | Hits / misses | Max RSS KiB |
| ------------- | -----------: | -------------: | ----------: | ------------- | ----------: |
| delivery-cold |      489.404 |        487.657 |        2181 | 0 / 2181      |      196632 |
| delivery-hit  |      199.261 |        197.384 |           0 | 2181 / 0      |      126072 |

Both final-source artifacts retain 3,510 files / 506,944,952 bytes and pass direct
publication validators. They preserve all 2,968 image files, 2,181 variants, six
recorded download hashes, 204 routes and 41 ordered recommendation lists against
the fresh production control. Only known build timestamps and linked tab UUIDs
vary. All 56 generation tests pass; final-source hashes are in the JSON. Actionlint,
Actions-lock verification, syntax and scoped normal hooks pass. Formatting twice
and final diff/secret checks are required before signing. The earlier retained
warm run is pre-review evidence; no final-source warm performance claim is made.
The single-run, cold-cost, unchanged-artifact and absent-CI-transport qualifications
remain in force. Fifteen representative live image/download hashes match control
before release. Remote checks, signing, merge and deployment remain separate gates,
whose evidence is maintained in the protected PR and main run rather than inferred
from these local results. All worktrees and local measurement evidence are retained.
