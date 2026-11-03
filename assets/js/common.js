// Small DOM enhancements; the document remains readable without JavaScript.
(() => {
  function initialize() {
    const toggle = document.querySelector(".navbar-toggler");
    const navigation = document.getElementById("navbarNav");
    const desktop = window.matchMedia("(min-width: 48rem)");
    function setNavigation(open) {
      if (!navigation || !toggle) return;
      navigation.hidden = !desktop.matches && !open;
      toggle.setAttribute("aria-expanded", String(!navigation.hidden));
      toggle.classList.toggle("collapsed", navigation.hidden);
    }
    window.SiteUI = { closeNavigation: () => setNavigation(false) };
    if (toggle && navigation) {
      document.documentElement.classList.add("nav-enhanced");
      setNavigation(false);
      toggle.addEventListener("click", () => setNavigation(navigation.hidden));
      desktop.addEventListener("change", () => setNavigation(false));
      document.addEventListener("keydown", (event) => {
        if (event.key === "Escape" && !desktop.matches && !navigation.hidden) {
          setNavigation(false);
          toggle.focus();
        }
      });
      navigation.addEventListener("click", (event) => {
        if (event.target.closest("a[href]")) setNavigation(false);
      });
    }
    if (typeof jekyllTabs !== "undefined") document.documentElement.classList.add("tabs-enhanced");

    // Progressive bibliography disclosures: all text is visible without JS.
    document.querySelectorAll(".bibliography li").forEach((entry, entryIndex) => {
      const controls = entry.querySelectorAll(".links button.abstract, .links button.award, .links button.bibtex");
      controls.forEach((control, controlIndex) => {
        const kind = ["abstract", "award", "bibtex"].find((name) => control.classList.contains(name));
        const panel = entry.querySelector(`div.${kind}.hidden`);
        if (!panel) return;
        panel.id ||= `citation-${entryIndex}-${controlIndex}`;
        panel.hidden = true;
        control.setAttribute("aria-controls", panel.id);
        control.setAttribute("aria-expanded", "false");
        control.addEventListener("click", () => {
          const opening = panel.hidden;
          controls.forEach((button) => {
            const target = document.getElementById(button.getAttribute("aria-controls"));
            if (target) target.hidden = true;
            button.setAttribute("aria-expanded", "false");
          });
          panel.hidden = !opening;
          control.setAttribute("aria-expanded", String(opening));
        });
      });
    });
    document.querySelectorAll("[data-authors-full]").forEach((button) => {
      button.addEventListener("click", () => {
        const opening = button.getAttribute("aria-expanded") !== "true";
        button.textContent = opening ? button.dataset.authorsFull : button.dataset.authorsShort;
        button.setAttribute("aria-expanded", String(opening));
      });
    });

    document.querySelectorAll("article table").forEach((table) => {
      if (table.closest("pre, code, .news, .archive, .table-scroll")) return;
      const wrapper = document.createElement("div");
      wrapper.className = "table-scroll";
      wrapper.tabIndex = 0;
      wrapper.setAttribute("role", "region");
      wrapper.setAttribute("aria-label", table.caption?.textContent || "Scrollable table");
      table.before(wrapper);
      wrapper.append(table);
      table.querySelectorAll("thead th:not([scope])").forEach((header) => header.setAttribute("scope", "col"));
    });

    const sidebar = document.getElementById("toc-sidebar");
    if (sidebar && "IntersectionObserver" in window) {
      const links = [...sidebar.querySelectorAll('a[href^="#"]')];
      const sections = links.map((link) => document.getElementById(decodeURIComponent(link.hash.slice(1)))).filter(Boolean);
      function indicate(section) {
        links.forEach((link) => {
          if (decodeURIComponent(link.hash.slice(1)) === section.id) link.setAttribute("aria-current", "location");
          else link.removeAttribute("aria-current");
        });
      }
      if (sections.length) indicate(sections[0]);
      const observer = new IntersectionObserver(
        () => {
          const boundary = (document.querySelector(".site-header")?.getBoundingClientRect().bottom || 0) + 32;
          const current = sections.filter((section) => section.getBoundingClientRect().top <= boundary).at(-1) || sections[0];
          if (current) indicate(current);
        },
        { rootMargin: "-10% 0px -65% 0px", threshold: [0, 1] }
      );
      sections.forEach((section) => observer.observe(section));
    }
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", initialize, { once: true });
  else initialize();
})();
