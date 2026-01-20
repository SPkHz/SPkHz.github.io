# Portfolio Site TODO

Suggestions for improving this portfolio site for hiring managers.

---

## Critical Issues (Fix First)

- [ ] **Placeholder LinkedIn URLs** - `_pages/about.md` lines 13-14 and 34 have placeholder LinkedIn links (`YOUR-LINKEDIN-HERE`, `PLACE-LINKEDIN-HERE`)
- [ ] **Default socials.yml data** - `_data/socials.yml` still has:
  - Placeholder email: `you@example.com`
  - Einstein's Google Scholar ID and InspireHEP ID
  - A "custom_social" link to alberteinstein.com
  - Missing GitHub username
- [ ] **CV data is Einstein's** - `_data/cv.yml` contains Albert Einstein's biography. Either update this file or ensure `resume.json` is properly configured
- [ ] **Syntax error in \_config.yml** - Line 281 has `first_name: Steven, M.]` (mismatched bracket)

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

- [ ] **Add a publications page** - If you have published work, conference papers, or senior thesis, add them to `_bibliography/papers.bib`
- [ ] **Create a dedicated Skills section** - Make skills more prominent on the about page with visual skill bars or categorized lists
- [ ] **Add project thumbnails** - Enable `enable_publication_thumbnails: true` in config and add preview images for key projects
- [ ] **Remove or customize books.md** - If not using the bookshelf feature, remove from navigation
- [ ] **Consider removing publications page** - If no publications yet, add `_pages/publications.md` to the exclude list

---

## Technical Features to Enable

- [ ] **Enable Giscus comments** - Uncomment and configure giscus in `_config.yml` (lines 107-120) for feedback on projects
- [ ] **Set up resume.json properly** - Review `assets/json/resume.json` to ensure it has YOUR education, work experience, and skills
- [ ] **Configure GitHub repositories display** - Update `_data/repositories.yml` to showcase your best repos

---

## Quick Wins

- [ ] **Remove unused template pages** - dropdown, teaching, profiles pages may be cluttering navigation
- [ ] **Add "Download Resume" button** - Ensure PDF exists at `assets/pdf/Steven_Placzek_Resume.pdf`
- [ ] **Consider a custom domain** - `stevenplaczek.com` or similar looks more professional than `spkhz.github.io`

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
