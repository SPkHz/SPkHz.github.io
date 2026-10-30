# Python consumers

The repository owns separate hash locks for notebook/site building, citation
updates, the pip installer and the audit scanner. Resolve from each adjacent
input using the reviewed uv resolver and CPython 3.13; retain full hashes.
Install pip 26.2.2 from its installer lock first, then the relevant consumer lock,
using `--require-hashes --only-binary=:all:`. Source builds and floating upgrades
are not part of CI installation.

Build workflows retain Jupyter 1.1.1 and use nbconvert 7.17.2, including the
notebook writer traversal repair. Citation requirements preserve the repository's
nbconvert, PyYAML and scholarly consumers; these are not another site's locks.
Tornado has a patched minimum of 6.5.5. Audit every resolved package, retaining
development-tool classifications and complete scanner coverage.

The source locks and local inert fixtures do not prove a deployed container's
installed package identity. Browser evidence remains bound to its unchanged
JavaScript consumers and fixtures, separately from these Python build consumers.
