# Native foundation baseline and bounded cleanup

Fresh remote `main`: `ffdb12425a433c492fc2e9d7572a474342310a84`.
The primary checkout, four maintenance worktrees and existing refs are preserved.
The approved plan and design are adjacent publication-excluded documents;
`NEXT_PLAN.md` remains the backlog.

The frozen rootless Podman toolchain reports Ruby 3.3.13, Bundler 4.0.15,
Node 24.22.1 and npm 11.19.1. Generation runs with container networking disabled.
The existing installed gem cache and exact formatter packages were reused;
no dependency version changed for this baseline.

| Measurement                             | Fresh baseline | Bounded cleanup |
| --------------------------------------- | -------------: | --------------: |
| Page routes (excluding asset documents) |            204 |             204 |
| Public files                            |          3,526 |           3,524 |
| Artifact bytes                          |    539,407,268 |     509,183,990 |
| Core CSS after existing purge           |         45,557 |          45,557 |
| Core compressed Sass before purge       |        638,957 |         638,957 |
| All local CSS bytes                     |        176,362 |         176,362 |
| All local JavaScript bytes              |        281,366 |         281,366 |
| npm locked packages, excluding root     |             34 |              34 |
| Cold production generation              |      484.841 s |               — |
| Warm production generation              |      196.308 s |       195.539 s |
| Cold responsive-image conversions       |          2,181 |               — |
| Warm responsive-image conversions       |              0 |               0 |

The warm measurement uses an isolated source snapshot at the same commit and
retains generated images. Jekyll's reported generation time excludes the
post-build CSS purge; wall times were 486.581 s cold and 198.184 s warm.
The related-content index remains enabled; optimizing it is separate work.

All 204 routes and their article text, code blocks and resource references match
between baseline and cleanup. SHA-256 comparisons preserve all 3,247 retained
non-CSS/JavaScript asset files, including engineering downloads and images.
Six distinct absolute local asset download destinations were recorded from
rendered links. Tables and equations remain in the article comparison, without
removing their values. Only the approved Plotly demo (4,231,458 bytes) and tutorial
video (25,991,824 bytes) are retired: 30,223,282 source bytes. The artifact reduction
is four bytes smaller because `/articles/` is longer than `/blog/` in the corrected
About heading link.

Source and runtime inventory confirm Bootstrap Table is a styling integration;
no sorting, search/filter or pagination option is configured. Sidebar highlighting
uses Bootstrap-Toc/scrollspy; bibliography disclosures use jQuery; the image error
handler removes every picture's source; blocked localStorage breaks theme setup.
The replacement regressions reproduce these couplings before implementation.

Fresh baseline browser sampling covers 36 cases at 390/768/1440 pixels, both
themes, 200% zoom and reduced motion: zero status, overflow, text-contrast or
script-error cases. Full replacement rendering and interaction gates remain
separate from this baseline. Screenshots and machine snapshots stay outside the
published artifact.

PASS: original 37-test suite; cleanup 38-test suite; production generation,
existing CSS purge, both publication validators, positive security.txt and
negative development/portrait/backlog/retired-sample fixtures. Independent,
read-only stage-1 review found no Critical, Important or Minor issues.
Network-free dependency baseline: 3 manifests, 38 dependencies, complete,
zero warnings. These counts are dependency data, not a host-exposure claim.

Remote PR checks, matching managed CodeQL, protected merge, main deployment and
live retained-route/retired-sample verification are release gates, recorded by
the release rather than inferred from these local results.
