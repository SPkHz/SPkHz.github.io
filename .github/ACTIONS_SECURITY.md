# Actions maintenance

Keep direct action references pinned to full commit SHAs. The adjacent comments
map each pin to the upstream ref reviewed on 2026-10-27; moving a tag does not
change a committed pin. Weekly Dependabot version updates require review and
must not be merged automatically.

The repository maintainer owns upstream release, advisory and shipped-bundle
review before accepting updates and before reusing retained branches.
Dependabot security alerts currently cover semantically versioned Actions;
SHA pins do not have that alert coverage. Version-update PRs alone therefore
do not establish security clearance. Keep the immutable pins.

Review the action's own runtime and executable bundle separately from the
application runtime selected by setup-node or setup-python. Also inspect nested
actions, reusable workflows, Docker digests and packages, tools or images
downloaded at execution time. A source SHA does not freeze those downloads.
The current direct-reference repair does not close those separate surfaces,
or the reported setup-python Undici and Claude Action body-parser/Zod findings.

Before a push or workflow invocation, review deployment, release, token/OIDC,
write-capable bot and auto-merge triggers. Existing manual activation and CI
holds remain authoritative. Historical green checks do not qualify a reused
branch; validate its entire resulting workflow tree and upstream action paths.

References: [secure use](https://docs.github.com/en/actions/reference/security/secure-use)
and [Dependabot alerts](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependabot-alerts).
