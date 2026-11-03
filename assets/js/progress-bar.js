// Keep the native progress element in sync without changing document geometry.
(() => {
  const progress = document.getElementById("progress");
  const backToTop = document.getElementById("back-to-top");
  const header = document.querySelector(".site-header");
  function update() {
    const height = header?.getBoundingClientRect().height || 0;
    document.documentElement.style.setProperty("--header-height", `${height}px`);
    if (backToTop) backToTop.hidden = window.scrollY < 200;
    if (!progress) return;
    progress.max = Math.max(1, document.documentElement.scrollHeight - window.innerHeight);
    progress.value = window.scrollY;
  }
  backToTop?.addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: window.matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth" });
  });
  window.addEventListener("scroll", update, { passive: true });
  window.addEventListener("resize", update);
  window.addEventListener("load", update, { once: true });
  if (header && "ResizeObserver" in window) new ResizeObserver(update).observe(header);
  update();
})();
