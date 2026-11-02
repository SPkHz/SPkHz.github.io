module.exports = {
  content: ["_site/**/*.html", "_site/**/*.js"],
  css: ["_site/assets/css/*.css"],
  output: "_site/assets/css/",
  skippedContentGlobs: ["_site/assets/**/*.html"],
  // MathJax creates these elements and attributes after the static build.
  safelist: { greedy: [/^mjx-/] },
};
