# Retained browser dependencies

This is the single retained-browser inventory. It is excluded from publication.
Generation uses local vendored distributions and never downloads executable dependencies.
The Ruby build and Sass compiler are locked in Gemfile.lock; formatter tooling is separate.

## Optional browser resources

| Library / version                   | Source and license                                                                                        | Consumers                                                          | Exact resource / SHA-384 SRI                                                                                                                                |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Image Comparison Slider 8.0.6 (js)  | [https://github.com/sneas/img-comparison-slider](https://github.com/sneas/img-comparison-slider), MIT     | `images.compare`: active band-pass filter project.                 | `https://cdn.jsdelivr.net/npm/img-comparison-slider@8.0.6/dist/index.min.js`<br>`sha384-x54aXXXAjvQJLfJCelTOjF19assbJKDdbMVHrVngH6/7ydrJqdf3uYQ6SQ1gBfDG`   |
| Image Comparison Slider 8.0.6 (css) | [https://github.com/sneas/img-comparison-slider](https://github.com/sneas/img-comparison-slider), MIT     | `images.compare`: active band-pass filter project.                 | `https://cdn.jsdelivr.net/npm/img-comparison-slider@8.0.6/dist/styles.min.css`<br>`sha384-G1cDNWmi4f8fIGnNsy2iiPgyC3H/+5p7jQesUfbuR8ELeKDmJGQPs8Ce95dWZ9TG` |
| MathJax 3.2.2 (js)                  | [https://github.com/mathjax/MathJax](https://github.com/mathjax/MathJax), Apache-2.0                      | Conservative default on all pages; explicit `math: false` opt-out. | `https://cdn.jsdelivr.net/npm/mathjax@3.2.2/es5/tex-mml-chtml.js`<br>`sha384-Wuix6BuhrWbjDBs24bXrjf4ZQ5aFeFWBuKkFekO2t8xFU0iNaLQfp2K6/1Nxveei`              |
| medium-zoom 1.1.0 (js)              | [https://github.com/francoischalifour/medium-zoom](https://github.com/francoischalifour/medium-zoom), MIT | Rendered pages containing `data-zoomable`.                         | `https://cdn.jsdelivr.net/npm/medium-zoom@1.1.0/dist/medium-zoom.min.js`<br>`sha384-o0gqi06am9fKVfa/jWO8/UE7OxHG6t+fgq/XaASsuwT8OBsFcxN7YhjtqyTfIxtS`       |
| Swiper 11.0.5 (js)                  | [https://github.com/nolimits4web/swiper](https://github.com/nolimits4web/swiper), MIT                     | `images.slider` pages: filter designs and amplifier designs.       | `https://cdn.jsdelivr.net/npm/swiper@11.0.5/swiper-element-bundle.min.js`<br>`sha384-S2Tvv62IAagvNoOboNO1Lfpixi8SpZ0aQfCDKDylSpctAHmaL5qzOr9SBh0mon52`      |
| Swiper 11.0.5 (css)                 | [https://github.com/nolimits4web/swiper](https://github.com/nolimits4web/swiper), MIT                     | `images.slider` pages: filter designs and amplifier designs.       | `https://cdn.jsdelivr.net/npm/swiper@11.0.5/swiper-bundle.min.css`<br>`sha384-eKrJLy2KlZuvuza/yNmSyFUE2Qb5aehRlXikp6XUOxXVw5pOQBb5n1C0UOcCnAJb`             |

## Vendored search modules

Search uses @deepdub/ninja-keys 1.2.11 (MIT), Lit 3.1.3 and lit-html 3.1.3
(BSD-3-Clause), lit-element 4.0.5 and @lit/reactive-element 2.0.4 (BSD-3-Clause),
and hotkeys-js 3.13.7 (MIT). Sources are the exact npm paths retained in each
distribution header. The vendored jsDelivr bundles retain their upstream headers;
builds do not regenerate or minify them. Consumers: search-enabled published pages.

Upstreams: [Ninja Keys](https://github.com/ssleptsov/ninja-keys),
[Lit](https://github.com/lit/lit), [hotkeys-js](https://github.com/jaywcjlove/hotkeys-js).

| Local distribution                                                            | Exact original source                                                    | SHA-256                                                            |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------ |
| `assets/js/search/base-styles.min.js`                                         | `/npm/@deepdub/ninja-keys@1.2.11/dist/base-styles.js`                    | `d105e0f88745c2eb94542f1e81573ba751839393eaea989e25edd4b91765ecd8` |
| `assets/js/search/command-score.min.js`                                       | `/npm/@deepdub/ninja-keys@1.2.11/dist/command-score.js`                  | `06e2860c7f3542a35248b45b803f26baa3527411539264d9722c5b18ce756985` |
| `assets/js/search/hotkeys-js/hotkeys.esm.min.js`                              | `/npm/hotkeys-js@3.13.7/dist/hotkeys.esm.js`                             | `12712a9b7214e85b027b8b329a1c071f3f1079824c923c6a42149eeff2cf6328` |
| `assets/js/search/lit/decorators.min.js`                                      | `/npm/lit@3.1.3/decorators.js`                                           | `c23fa90278dea7019e6a93a0faafd4a420595998d9ff807f3f73f84863cefd8e` |
| `assets/js/search/lit/directives/class-map.min.js`                            | `/npm/lit@3.1.3/directives/class-map.js`                                 | `bafb64bd6145c0679dcf2395d1d19f25e3b900015b5f3aa0448cc9e2d87decf4` |
| `assets/js/search/lit/directives/join.min.js`                                 | `/npm/lit@3.1.3/directives/join.js`                                      | `12709bec3dc1305c5180cbc17d589439246f9ae147a99aa45293189e52cb52f0` |
| `assets/js/search/lit/directives/live.min.js`                                 | `/npm/lit@3.1.3/directives/live.js`                                      | `e971cabd52264f56982e1cbfc897fdccae1bf6dc8fdb362e0fc55d4ac89a0ec0` |
| `assets/js/search/lit/directives/ref.min.js`                                  | `/npm/lit@3.1.3/directives/ref.js`                                       | `939651ebda2f1e9075204586fb4c4083e4d7c25e969069abf9f030a7d53b2adf` |
| `assets/js/search/lit/directives/repeat.min.js`                               | `/npm/lit@3.1.3/directives/repeat.js`                                    | `2efa664792a3fc78e40d7a6e02f718a2b7ef191f01c7a1d056a4d8a789b22550` |
| `assets/js/search/lit/directives/unsafe-html.min.js`                          | `/npm/lit@3.1.3/directives/unsafe-html.js`                               | `6c5e4980abab5cb8797d9600101fbda55a44cb1c75e38ec9bfde17dab0c00082` |
| `assets/js/search/lit/index.min.js`                                           | `/npm/lit@3.1.3/index.js`                                                | `09a2cbedfc9eac8f28c0162fd9984ebf1a688aa0bd93377fea7acd6a6d89e3ae` |
| `assets/js/search/lit-element/lit-element.min.js`                             | `/npm/lit-element@4.0.5/lit-element.js`                                  | `e2f3e4e91c5f63f0935943fac18997d7bbae2d7cc0df6d9ccace36084b0ea89d` |
| `assets/js/search/lit-html/directives/class-map.min.js`                       | `/npm/lit-html@3.1.3/directives/class-map.js`                            | `fb1721a3c812fc58b5a7659a9a18303a3658f7683766903ab04aed5b51870f9e` |
| `assets/js/search/lit-html/directives/join.min.js`                            | `/npm/lit-html@3.1.3/directives/join.js`                                 | `af15ab57a3c301eb023c5944068a0fd4283420fb8618f84a38105940f2994bd9` |
| `assets/js/search/lit-html/directives/live.min.js`                            | `/npm/lit-html@3.1.3/directives/live.js`                                 | `f6382dcd0a976edff71e677f7eb05c9012ade5b1bdd050a8346aa484ab9239f1` |
| `assets/js/search/lit-html/directives/ref.min.js`                             | `/npm/lit-html@3.1.3/directives/ref.js`                                  | `662996bf13a8a55755b6b547a9ea44077959fbf2fca3ac6f417e3538cfd537dc` |
| `assets/js/search/lit-html/directives/repeat.min.js`                          | `/npm/lit-html@3.1.3/directives/repeat.js`                               | `b329b2af682514ea1f07cd60f23670aede2192b514abd8659c737520f274ee52` |
| `assets/js/search/lit-html/directives/unsafe-html.min.js`                     | `/npm/lit-html@3.1.3/directives/unsafe-html.js`                          | `7163829d15732d45afbb5c363d88d0bc0f8b4dcf6b2547c57c9277a41e61e68a` |
| `assets/js/search/lit-html/is-server.min.js`                                  | `/npm/lit-html@3.1.3/is-server.js`                                       | `8bb28c742f0e67d766945a8a0598e47a7a6791fd4cc487b4d4e321b3d7de4d6b` |
| `assets/js/search/lit-html/lit-html.min.js`                                   | `/npm/lit-html@3.1.3/lit-html.js`                                        | `f21e6c3fbb91d2d5f76f2bc2418e89bf06cbd11b632a06eeb8d509e61376215d` |
| `assets/js/search/ninja-action.min.js`                                        | `/npm/@deepdub/ninja-keys@1.2.11/dist/ninja-action.js`                   | `629f86eca48eab1222121bdbf2363bc2c971c3975ce67dd0da4d69a3f2b641b5` |
| `assets/js/search/ninja-footer.min.js`                                        | `/npm/@deepdub/ninja-keys@1.2.11/dist/ninja-footer.js`                   | `1a0719c6867eaf3fc99e65012154ce68748da5079ea189fb75c615b3871ed502` |
| `assets/js/search/ninja-header.min.js`                                        | `/npm/@deepdub/ninja-keys@1.2.11/dist/ninja-header.js`                   | `9e8d66aef937f10ff8297e38badfd42595ec06f43ca850c7e051b43114020b74` |
| `assets/js/search/ninja-keys.min.js`                                          | `/npm/@deepdub/ninja-keys@1.2.11/dist/ninja-keys.js`                     | `36f7aa6cfa69221f917c790241d6d422a3833d5d323adef57e50265f25e261f4` |
| `assets/js/search/reactive-element/decorators/custom-element.min.js`          | `/npm/@lit/reactive-element@2.0.4/decorators/custom-element.js`          | `8e32e0f39eda1c3b4b518bdb8c04761c20a0e2231562b6c867811dc29ae99b51` |
| `assets/js/search/reactive-element/decorators/event-options.min.js`           | `/npm/@lit/reactive-element@2.0.4/decorators/event-options.js`           | `bf51526a246979e9bb684cac935084acec202406236fbefba67a7fbfa04530fc` |
| `assets/js/search/reactive-element/decorators/property.min.js`                | `/npm/@lit/reactive-element@2.0.4/decorators/property.js`                | `3b7de50040e8e973fd4315d4bcac412345c73fc630d714b97c4dd699ddf0110f` |
| `assets/js/search/reactive-element/decorators/query-all.min.js`               | `/npm/@lit/reactive-element@2.0.4/decorators/query-all.js`               | `14222658e50c55b9a020afae8326964c92b7bf798dd5a38aeaa43e077587f2eb` |
| `assets/js/search/reactive-element/decorators/query-assigned-elements.min.js` | `/npm/@lit/reactive-element@2.0.4/decorators/query-assigned-elements.js` | `14834adaffeff4c815474de0f32e1cb9c575cc4fa73265225ca64b00c8759add` |
| `assets/js/search/reactive-element/decorators/query-assigned-nodes.min.js`    | `/npm/@lit/reactive-element@2.0.4/decorators/query-assigned-nodes.js`    | `260f3260a587f36dba819592e468ac11dfbe5b6d7c9dba62bcae5efc31ae311d` |
| `assets/js/search/reactive-element/decorators/query-async.min.js`             | `/npm/@lit/reactive-element@2.0.4/decorators/query-async.js`             | `59215a61b30dab42e0775d7a75d34e5d48ae0808542c247c8a4eb63f0453abaa` |
| `assets/js/search/reactive-element/decorators/query.min.js`                   | `/npm/@lit/reactive-element@2.0.4/decorators/query.js`                   | `398ca60662e98da549bfd60a456e344d615b2d7961c770e23b3ab5c24a4328f5` |
| `assets/js/search/reactive-element/decorators/state.min.js`                   | `/npm/@lit/reactive-element@2.0.4/decorators/state.js`                   | `0da4a245c6b54f1cd370dd75314d8bd3c4000665c141acaaaf410a93685884b3` |
| `assets/js/search/reactive-element/reactive-element.min.js`                   | `/npm/@lit/reactive-element@2.0.4/reactive-element.js`                   | `1ae8a925129cdb0f61e63d044a42ffa0bca223c8ccc51236ad8d24d4296af151` |

## Tabs, syntax themes and fonts

| Resource                                          | Version / source / license                                                                                  | Consumers and checksum                                                                                                                            |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `assets/js/tabs.min.js`                           | Jekyll Tabs 1.2.1; https://github.com/Ovski4/jekyll-tabs; MIT                                               | `tabs: true`: active band-pass filter. Retained distribution bytes.<br>SHA-256 `c3ed9a746632619aa0d0b7654a8c4799a4d67949abea88f6d5ebf8423ea0bb51` |
| `assets/css/jekyll-pygments-themes-github.css`    | https://github.com/jwarby/jekyll-pygments-themes; MIT; retained file revision identified by checksum        | Light syntax highlighting.<br>SHA-256 `d40ec7e75a8743243819ca2e857f9fd32fda8138b139f6a7bfc33fdde72f4440`                                          |
| `assets/css/jekyll-pygments-themes-native.css`    | https://github.com/jwarby/jekyll-pygments-themes; MIT; retained file revision identified by checksum        | Dark syntax highlighting.<br>SHA-256 `53cee24c69c2a59b82b2ea06444b088b25c1eb0394b969a6a610c66ccbf10173`                                           |
| `assets/webfonts/fa-brands-400.woff2`             | Font Awesome Free 6.7.1; https://fontawesome.com/license/free; Fonts SIL OFL 1.1, icons CC BY 4.0, code MIT | Only glyphs in `_sass/_icons-used.scss`.<br>SHA-256 `4d46c3bcd49e008582f1c01ee88ed9a494d150643e3e947eb7710180808403c9`                            |
| `assets/webfonts/fa-solid-900.woff2`              | Font Awesome Free 6.7.1; https://fontawesome.com/license/free; Fonts SIL OFL 1.1, icons CC BY 4.0, code MIT | Only glyphs in `_sass/_icons-used.scss`.<br>SHA-256 `38e76ab3d359e772e9f2aab11fbb07a2e2209318183a89ced0a97d6b958a7a6f`                            |
| `assets/fonts/JetBrainsMono-Italic.woff2`         | JetBrains Mono 2.304; https://github.com/JetBrains/JetBrainsMono; SIL OFL 1.1                               | Regular/italic and 400/600 code faces.<br>SHA-256 `9f158b85eca345daeee01dfffa602709a905ea08b0cc60dbf6153cbbd97da08f`                              |
| `assets/fonts/JetBrainsMono-Regular.woff2`        | JetBrains Mono 2.304; https://github.com/JetBrains/JetBrainsMono; SIL OFL 1.1                               | Regular/italic and 400/600 code faces.<br>SHA-256 `f1a7a03672cdd494ce0d5543fac6e4360fe22403c6de297fdc2e55a815f7baff`                              |
| `assets/fonts/JetBrainsMono-SemiBold.woff2`       | JetBrains Mono 2.304; https://github.com/JetBrains/JetBrainsMono; SIL OFL 1.1                               | Regular/italic and 400/600 code faces.<br>SHA-256 `8f20245500c375a63879b47c12560a07bcaf7a88672d272f4d8e79b68f9186ae`                              |
| `assets/fonts/JetBrainsMono-SemiBoldItalic.woff2` | JetBrains Mono 2.304; https://github.com/JetBrains/JetBrainsMono; SIL OFL 1.1                               | Regular/italic and 400/600 code faces.<br>SHA-256 `c5b57341b76836b0eec23b7b1a70c4859f1645c7f19542ec1ccf0a6e6f6688a2`                              |
| `assets/fonts/tabler-icons-filled.woff2`          | Tabler Icons 3.20.0; https://github.com/tabler/tabler-icons; MIT                                            | Search and theme controls; existing fonts and attribution retained.<br>SHA-256 `eb945e73b755eb2719992cbf2fc5195709437a40f633a1bcc36fa3b334f60b4a` |
| `assets/fonts/tabler-icons.woff2`                 | Tabler Icons 3.20.0; https://github.com/tabler/tabler-icons; MIT                                            | Search and theme controls; existing fonts and attribution retained.<br>SHA-256 `2f862c0efea46984c4d380ba9dc5e3924c23477e8a997ab51d553582742b042b` |

## Review and update procedure

1. Confirm a published consumer before adding or retaining a resource. Use existing
   `tabs`, `images.slider`, `images.compare` and zoomable-content flags; mathematical
   content keeps the conservative default. A new page must opt out of math explicitly.
2. Review the official upstream release, source and license. Fetch exact bytes only
   during the authorized maintenance review; never fetch executable code during generation.
3. Preserve minified upstream distributions and license headers. Recalculate SHA-384
   SRI for every CDN URL and SHA-256 for each vendored file/font in this inventory.
   Pin exact versions. No `latest`, floating CDN range or replacement CSS optimizer.
4. Update this inventory and the config together. For an added icon, include its
   existing-font glyph and upstream attribution in `_sass/_icons-used.scss`.
5. Run the Node-free generation suite/build, both publication validators, isolated
   formatting and JS syntax checks, and the browser matrix with keyboard/no-JS checks.
   Review lock diffs; use signed protected PRs with matching managed CodeQL.

Routine dependency PRs run on the first and fifteenth at 09:00 America/New_York.
Security-update groups remain separate; GitHub-managed vulnerability alerts and
security updates remain active between those windows. Human review is required;
automatic merging remains prohibited.

The unused Academicons and Scholar Icons stylesheets remain in source for their
upstream attribution, but are excluded from publication. Existing font URLs and
font files remain available; the core emits only the glyphs listed above.

The first-party search setup adapts the pinned Ninja Action `highlightMatch`
boundary to build DOM text nodes from decoded match positions. Trusted SVG/emoji
decorations retain a narrow attribute allowlist. Vendored distribution bytes are
unchanged. Browser regressions must pass for quotes, apostrophes, ampersands,
Unicode, inert markup, shortcut toggling and focus return on every search upgrade.
Rendered inline-announcement HTML is decoded once before Liquid escapes its title.
