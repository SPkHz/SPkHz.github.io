# Portfolio Site TODO

## Branding / Page Titles / Information Hierarchy

- [x] Make the H1/page hero title page-specific (Blog page should not show "Electrical Engineering Portfolio"). ✅ **COMPLETED** - H1 now shows just name "Steven M. Placzek"
- [x] Update the Home page H1 to a hiring-manager-oriented title (e.g., "Electrical Engineer — Projects & Case Studies"). ✅ **COMPLETED** - Shows name with professional tagline
- [x] Shorten and rewrite the hero description to be scannable (focus on selected work + skills, not "all my coursework"). ✅ **COMPLETED** - Rewrote to be more professional and scannable
- [x] Add 1-line role/skill tagline under the name (e.g., "RF • DSP • Embedded • Test & Measurement"). ✅ **COMPLETED** - Added "RF • DSP • Embedded • Millimeter-Wave • Test & Measurement"
- [x] Add primary CTA buttons under the hero: "View Resume (PDF)", "Projects", "GitHub/Code", "Contact". ✅ **COMPLETED** - CTA buttons already exist in about.md
- [x] Rename nav labels for clarity: BLOG → "Technical Blog/Engineering Notes"; REPOSITORIES → "Code/GitHub". ✅ **COMPLETED** - Changed to "Blog" and "GitHub"
- [x] Add a "Contact" destination (page or header buttons with email + LinkedIn). ✅ **COMPLETED** - Contact page already exists at /contact/

## Color System (Light/Dark Mode)

- [ ] Define theme tokens with CSS variables (e.g., --accent, --accent-hover, --text, --bg, --muted, --border).
- [ ] Replace light-mode magenta with a more professional accent (Deep Navy / Deep Teal / Steel Blue).
- [ ] Replace dark-mode bright cyan with a less-neon accent (Muted Aqua OR Soft Amber OR Sage).
- [ ] Use the same accent hue across both themes (different luminance, same brand color).
- [ ] Standardize link colors + hover/visited states for both themes.
- [ ] Ensure color contrast meets WCAG AA for normal text (especially nav links + tag links).
- [ ] Add a visible keyboard focus style (focus ring) that works in both themes.

## Typography & Layout

- [ ] Reduce the hero H1 size on desktop and add responsive scaling for mobile (avoid oversized 3-line headline).
- [ ] Set an intentional type scale (H1/H2/H3/body) and consistent line-height across the site.
- [ ] Constrain paragraph width (e.g., max-width: 65–75ch) for the hero description and post excerpts.
- [ ] Improve vertical rhythm: consistent spacing between hero, tag row, and content lists.
- [ ] Make section separators (rules) lighter/subtler and consistent in both modes.

## Header / Navigation Polish

- [ ] Increase nav item hit-area (padding) for easier clicking.
- [ ] Use an active-state style beyond just color (underline/border/weight) for accessibility.
- [ ] Add tooltips and aria-labels for the header icons (theme toggle/search/etc.).
- [ ] Ensure header icons use consistent size, stroke weight, and alignment baseline.
- [ ] Make the site title (top-left) link to Home and shorten it (e.g., "Steven M. Placzek | EE").

## Blog / Project Listing Presentation

- [ ] Convert post listings into consistent "cards" (title, meta, tags, thumbnail) with a clear hover state.
- [ ] Standardize thumbnail aspect ratio + size so rows align cleanly.
- [ ] Improve mobile layout: stack thumbnail below/above text with consistent spacing.
- [ ] Make post meta (date/read time) smaller and visually secondary.
- [ ] Reduce tag clutter: show top tags + "More…" expand, or move tags into a filter panel.
- [ ] Restyle hashtag links as “chips” with consistent padding/border (instead of inline text + separators).
- [ ] Add a "Featured/Selected" section at top (3–6 best projects) before the full list.
- [ ] Add quick filters for content types: Projects vs Coursework vs Notes (if applicable).

## Accessibility

- [ ] Verify only one H1 per page and correct heading order (H1 → H2 → H3).
- [ ] Ensure all interactive elements are keyboard reachable and have visible focus.
- [ ] Ensure icon-only buttons have accessible names (aria-label).
- [ ] Add a "Skip to content" link for keyboard users.
- [ ] Ensure link styling is not color-only (underline on hover/focus, or always-underlined in body content).

## Performance / Fit-and-Finish

- [ ] Enable responsive images (srcset/sizes) and lazy-load thumbnails.
- [ ] Compress thumbnails and enforce modern formats where possible (WebP/AVIF).
- [ ] Prevent layout shift by reserving image dimensions (width/height or aspect-ratio).
- [ ] Add consistent favicon + social preview (Open Graph) styling that matches the chosen accent color.
- [ ] Audit spacing/alignment across themes to ensure dark/light mode feel equally “finished”.

---

## Critical Issues (Fix First)

- [ ] **Placeholder LinkedIn URLs** - `_pages/about.md` lines 13-14 and 34 have placeholder LinkedIn links (`YOUR-LINKEDIN-HERE`, `PLACE-LINKEDIN-HERE`)

---

## Professional Polish

- [ ] **Enable Open Graph meta tags** - Set `serve_og_meta: true` in `_config.yml` (line 70) for proper LinkedIn/Twitter preview cards
- [ ] **Add a real profile photo** - Ensure `assets/img/prof_pic.jpg` is a professional headshot
- [ ] **Update footer text** - Footer in `_config.yml` (lines 11-13) could include name/copyright
- [ ] **Enable social icons on about page** - Set `social: true` in `_pages/about.md` (line 16)

---

## SEO & Discoverability

- [ ] **Add Google Analytics** - Set up `google_analytics` in `_config.yml` (line 80)
- [ ] **Enable Google Search Console verification** - Configure `google_site_verification` for search indexing
- [ ] **Add more keywords** - Consider adding to `_config.yml` (line 14): `analog-design`, `pcb`, `ltspice`, `keysight-ads`, `matlab`, `python`, `embedded-systems`

---

## Content Enhancements

- [ ] **Create a dedicated Skills section** - Make skills more prominent on the about page with visual skill bars or categorized lists
- [ ] **Add project thumbnails** - Enable `enable_publication_thumbnails: true` in config and add preview images for key projects
- [ ] **Remove or customize books.md** - If not using the bookshelf feature, remove from navigation
- [ ] **Consider removing publications page** - If no publications yet, add `_pages/publications.md` to the exclude list

---

## Technical Features to Enable

- [ ] **Enable Giscus comments** - Uncomment and configure giscus in `_config.yml` (lines 107-120) for feedback on projects
- [x] **Set up resume.json properly** - Review `assets/json/resume.json` to ensure it has YOUR education, work experience, and skills ✅ **COMPLETED**
- [x] **Configure GitHub repositories display** - Update `_data/repositories.yml` to showcase your best repos ✅ **COMPLETED**

---

## Quick Wins

- [ ] **Move unused template pages to archive** - dropdown, teaching, profiles pages may be cluttering navigation
- [ ] **Add "Download Resume" button** - Ensure PDF exists at `assets/pdf/Steven_Placzek_Resume.pdf`

---

## File Reference

| File                                   | What to Update                                         |
| -------------------------------------- | ------------------------------------------------------ |
| `_config.yml`                          | Open Graph, analytics, keywords, syntax fix (line 281) |
| `_pages/about.md`                      | LinkedIn URLs, enable social icons                     |
| `_data/socials.yml`                    | Email, GitHub, remove Einstein data                    |
| `_data/cv.yml`                         | Replace Einstein's CV with yours (or use resume.json)  |
| `assets/json/resume.json`              | Your actual resume data                                |
| `_data/repositories.yml`               | Your GitHub repos to feature                           |
| `assets/img/prof_pic.jpg`              | Professional headshot                                  |
| `assets/pdf/Steven_Placzek_Resume.pdf` | Your resume PDF                                        |
