// The upstream helper is loaded only on pages containing zoomable images.
window.medium_zoom = mediumZoom("[data-zoomable]", {
  background: getComputedStyle(document.documentElement).getPropertyValue("--global-bg-color").trim(),
});
