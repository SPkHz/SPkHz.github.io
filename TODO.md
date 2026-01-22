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
- [ ] Use the same accent hue across both themes (different luminance, same brand color).
- [ ] Standardize link colors + hover/visited states for both themes.
- [ ] Ensure color contrast meets WCAG AA for normal text (especially nav links + tag links).
- [ ] Add a visible keyboard focus style (focus ring) that works in both themes.

## Typography & Layout

- [x] Reduce the hero H1 size on desktop and add responsive scaling for mobile (avoid oversized 3-line headline). ✅ **COMPLETED** - Reduced hero H1 from 5rem to 2.75rem (display size), with responsive scaling to 2rem on tablets and 1.75rem on mobile
- [x] Set an intentional type scale (H1/H2/H3/body) and consistent line-height across the site. ✅ **COMPLETED** - Implemented Minor Third (1.2) type scale with CSS variables: H1=2.25rem, H2=1.875rem, H3=1.5rem, H4=1.25rem, H5=1.125rem, H6=1rem, plus consistent line-heights (--leading-tight: 1.2, --leading-snug: 1.375, --leading-normal: 1.5, --leading-relaxed: 1.625)
- [x] Constrain paragraph width (e.g., max-width: 65–75ch) for the hero description and post excerpts. ✅ **COMPLETED** - Added --content-width-prose: 70ch variable and applied to .prose, article p, .post-description, .desc, and post list paragraphs
- [x] Improve vertical rhythm: consistent spacing between hero, tag row, and content lists. ✅ **COMPLETED** - Created spacing scale with CSS variables (--space-xs through --space-3xl) and applied consistently to .header-bar, .tag-category-list, .post-list, .post-header, and .featured-posts
- [x] Make section separators (rules) lighter/subtler and consistent in both modes. ✅ **COMPLETED** - Updated hr element with opacity: 0.5 and consistent margin using --space-xl

## Header / Navigation Polish

- [x] Increase nav item hit-area (padding) for easier clicking. ✅ **COMPLETED** - Increased `.nav-link` padding to `0.75rem 1rem` for larger click targets
- [x] Use an active-state style beyond just color (underline/border/weight) for accessibility. ✅ **COMPLETED** - Added underline indicator (::after pseudo-element) to active nav items, plus visible focus rings for keyboard navigation
- [x] Add tooltips and aria-labels for the header icons (theme toggle/search/etc.). ✅ **COMPLETED** - Added descriptive `title` and `aria-label` attributes to search and theme toggle buttons, plus `aria-hidden="true"` on decorative icons
- [x] Ensure header icons use consistent size, stroke weight, and alignment baseline. ✅ **COMPLETED** - Standardized icon sizing to 1.25rem with flexbox alignment, added consistent padding, hover states, and focus styles
- [x] Make the site title (top-left) link to Home and shorten it (e.g., "Steven M. Placzek | EE"). ✅ **SKIPPED** - Site title already links to home; keeping full title as requested

## Blog / Project Listing Presentation

- [x] Convert post listings into consistent "cards" (title, meta, tags, thumbnail) with a clear hover state. ✅ **COMPLETED** - Created new `.post-card` component with `.post-card-link`, `.post-card-inner`, `.post-card-thumbnail`, `.post-card-content`, `.post-card-title`, `.post-card-description`, `.post-card-meta`, and `.post-card-tags` elements. Cards have border, rounded corners, hover lift effect with shadow, and title color change on hover.
- [x] Standardize thumbnail aspect ratio + size so rows align cleanly. ✅ **COMPLETED** - Thumbnails use fixed 280px width on desktop with `object-fit: cover` and min-height: 180px. Mobile uses full width with fixed 160-200px heights.
- [x] Have thumbnails alternate their positioning (align left alternate with align right) every over row. ✅ **COMPLETED** - Used CSS `:nth-child(even) .post-card-inner { flex-direction: row-reverse; }` to alternate thumbnail position on even cards.
- [x] Improve mobile layout: stack thumbnail below/above text with consistent spacing. ✅ **COMPLETED** - Added responsive breakpoints at 768px and 576px that switch to `flex-direction: column` and adjust thumbnail heights and padding.
- [x] Make post meta (date/read time) smaller and visually secondary. ✅ **COMPLETED** - Meta now uses `--type-xs` (0.75rem/12px) with `--global-text-color-light` for visual de-emphasis.
- [x] Reduce tag clutter: show top tags + "More…" expand, or move tags into a filter panel. ✅ **COMPLETED** - Shows only first 3 tags with a "+N more" button that toggles `.show-all-tags` class to reveal remaining tags using `display: contents`.
- [x] Restyle hashtag links as "chips" with consistent padding/border (instead of inline text + separators). ✅ **COMPLETED** - Created `.tag-chip` class with pill shape (border-radius: 100px), padding, border, hover states, and variants for categories (dashed border) and year (subtle background).
- [x] Add a "Featured/Selected" section at top (3–6 best projects) before the full list. ✅ **COMPLETED** - Created `.featured-section` with grid layout of `.featured-card` elements. Added `featured: true` to 4 best projects: EE456 Design 01 (15 GHz HEMT), EE456 Design 03 (10-20 GHz Chebyshev), EE470 Design 01 (Control Systems), and EE314 Design 01 (TL Matching).

## Further Blog / Project Listing Presentation Work

- [ ] Add quick filters for content types: Projects vs Coursework vs Notes (if applicable).

## Accessibility

- [x] Verify only one H1 per page and correct heading order (H1 → H2 → H3). ✅ **COMPLETED** - Fixed book-shelf.liquid (changed year headings from H1 to H2), verified cv.liquid and archive.liquid have conditional H1 logic
- [x] Ensure all interactive elements are keyboard reachable and have visible focus. ✅ **COMPLETED** - Added global focus styles for buttons, links, tag-chips, post-cards (`:focus-within`), and featured-cards in _base.scss
- [x] Ensure icon-only buttons have accessible names (aria-label). ✅ **COMPLETED** - All social icons in social.liquid have `aria-label` attributes and `aria-hidden="true"` on icons; header buttons already had proper labels
- [x] Add a "Skip to content" link for keyboard users. ✅ **COMPLETED** - Added `.skip-link` in header.liquid targeting `#main-content` in default.liquid, with CSS that shows link on keyboard focus
- [x] Ensure link styling is not color-only (underline on hover/focus, or always-underlined in body content). ✅ **COMPLETED** - Added default underlines for body content links (article, prose, main paragraphs) with subtle color that intensifies on hover; excluded nav/UI links that have other visual context

## Performance / Fit-and-Finish

- [x] Enable responsive images (srcset/sizes) and lazy-load thumbnails. ✅ **COMPLETED** - Created `responsive-thumbnail.liquid` include with srcset/sizes support for WebP, updated blog.md to use it for featured cards and post cards, added picture element CSS support
- [x] Compress thumbnails and enforce modern formats where possible (WebP/AVIF). ✅ **COMPLETED** - WebP at 85% quality already configured via imagemagick, added AVIF support preparation in `responsive-thumbnail.liquid` (AVIF config ready to enable when ImageMagick supports it)
- [x] Prevent layout shift by reserving image dimensions (width/height or aspect-ratio). ✅ **COMPLETED** - Added `aspect-ratio: 16/10` to post card thumbnails, explicit heights on mobile breakpoints, added `decoding="async"` to images, added aspect-ratio to project cards
- [x] Add consistent favicon + social preview (Open Graph) styling that matches the chosen accent color. ✅ **COMPLETED** - Enabled `serve_og_meta: true` and `serve_schema_org: true`, created custom SVG favicon (favicon.svg) in Deep Navy + Aqua accent colors, created og-preview.svg social preview, set og_image to profile picture
- [x] Audit spacing/alignment across themes to ensure dark/light mode feel equally "finished". ✅ **COMPLETED** - Added `--global-theme-color-rgb` CSS variable for both themes, added `--global-shadow-sm/md/lg/xl` variables with appropriate values for light/dark modes, updated shadows to use theme-aware variables

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
