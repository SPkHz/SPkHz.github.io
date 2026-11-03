# Approved native foundation design

## Summary and approved decisions

Goal: Improve the portfolio’s security posture and reduce recurring maintenance while preserving its useful features and engineering content.

Architecture: Keep Jekyll, Liquid, and the existing Ruby Sass compiler. Replace the general-purpose theme foundation with native HTML/CSS and small JavaScript helpers. Generate the published site without Node/npm; retain Node only
for isolated formatting and JavaScript checks.

Execution default: Use superpowers:executing-plans with one implementer and independent review at delivery boundaries.

The approved direction preserves:

• All 55 projects, article routes, technical downloads, equations, tables, tabs, sliders, and bibliography functionality.
• Search and keyboard shortcuts, manual light/dark/system selection, image zoom, sidebar navigation, code copying, and progress/back-to-top controls.
• Existing thumbnails, palette, typography, navigation wording, board imagery, /people/, and publication/privacy protections.
• Frozen dependencies, rootless Podman, protected signed PRs, the generated Actions lock, and GitHub-managed security services.

The measurable targets are:

Area Target
━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Site generation Works with Node/npm unavailable and without node_modules
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
npm dependencies Remove PurgeCSS; approximately 34 → 7 locked package entries at current formatter pins
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Theme foundation Remove Bootstrap 4, MDB, jQuery, Masonry, and obsolete supporting integrations
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Core stylesheet At most 65,536 bytes uncompressed; report widget CSS and fonts separately
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Routine maintenance Grouped updates on the 1st and 15th, 09:00 America/New_York
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Security updates Remain active between routine maintenance windows
──────────────────────────── ─────────────────────────────────────────────────────────────────────────────────────────────
Approved sample retirement Remove the Plotly demonstration and al-folio tutorial video, approximately 30.2 MB combined

This follows the reference site’s preference for native browser capabilities while retaining a proportionate static-site generator. Bootstrap’s official documentation confirms that the installed 4.6.2 foundation is out of support.

The operator-supplied implementation plan is the authority for acceptance and boundaries. No separate prior design file was supplied. Preserve all technical content, download URLs and image URLs except the two explicitly retired samples.
