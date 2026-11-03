const ninjaKeys = document.querySelector("ninja-keys");
ninjaKeys?.classList.toggle("dark", determineComputedTheme() === "dark");
let searchReturnTarget;
const isVisibleSearchTarget = (element) => element && !element.closest("[hidden]") && element.getClientRects().length > 0;

// The pinned renderer mixes decoded match offsets with encoded HTML. Build text
// nodes at that boundary, retaining only the trusted SVG/emoji decorations.
const highlightSearchTitle = (markup, indices = []) => {
  const template = document.createElement("template");
  template.innerHTML = markup;
  const result = document.createDocumentFragment();
  const matches = new Set(indices);
  let offset = 0;
  const append = (source, target) => {
    if (source.nodeType === Node.TEXT_NODE) {
      let plain = "";
      const flush = () => {
        if (plain) target.append(document.createTextNode(plain));
        plain = "";
      };
      for (const character of source.textContent) {
        const matched = matches.has(offset) || (character.length === 2 && matches.has(offset + 1));
        if (matched) {
          flush();
          const node = document.createElement("span");
          node.className = "highlight";
          node.textContent = character;
          target.append(node);
        } else {
          plain += character;
        }
        offset += character.length;
      }
      flush();
      return;
    }
    if (source.nodeType !== Node.ELEMENT_NODE) return;
    if (["script", "style"].includes(source.localName)) return;
    let decoration;
    if (["svg", "path"].includes(source.localName)) {
      decoration = document.createElementNS("http://www.w3.org/2000/svg", source.localName);
      for (const name of ["width", "height", "viewBox", "d", "stroke", "stroke-width", "fill", "fill-rule", "stroke-linecap", "stroke-linejoin"]) {
        const value = source.getAttribute(name);
        if (value === null) continue;
        if (["fill", "stroke"].includes(name) && !/^(none|currentColor|#[a-f0-9]{3,8})$/i.test(value)) continue;
        decoration.setAttribute(name, value);
      }
    } else if (source.localName === "img" && source.classList.contains("emoji")) {
      const url = new URL(source.getAttribute("src"), document.baseURI);
      if (url.protocol !== "https:" && url.origin !== window.location.origin) return;
      decoration = document.createElement("img");
      decoration.src = url.href;
      decoration.className = "emoji";
      for (const name of ["alt", "title", "width", "height"]) {
        if (source.hasAttribute(name)) decoration.setAttribute(name, source.getAttribute(name));
      }
    }
    if (decoration) target.append(decoration);
    source.childNodes.forEach((child) => append(child, decoration || target));
  };
  template.content.childNodes.forEach((child) => append(child, result));
  return result;
};

customElements.whenDefined("ninja-action").then(() => {
  // Keep upstream distribution bytes intact; this adapter is version-pinned and
  // covered against the real component, including its decoded match indices.
  customElements.get("ninja-action").prototype.highlightMatch = highlightSearchTitle;
});
customElements.whenDefined("ninja-keys").then(() => {
  const close = ninjaKeys.close.bind(ninjaKeys);
  ninjaKeys.close = () => {
    const wasVisible = ninjaKeys.visible;
    close();
    if (wasVisible) {
      ninjaKeys.updateComplete.then(() => {
        if (!ninjaKeys.visible && isVisibleSearchTarget(searchReturnTarget)) searchReturnTarget.focus();
      });
    }
  };
});
const openSearchModal = async () => {
  const opener = document.activeElement;
  window.SiteUI?.closeNavigation();
  searchReturnTarget =
    isVisibleSearchTarget(opener) && opener !== document.body && opener !== ninjaKeys
      ? opener
      : [document.getElementById("search-toggle"), document.querySelector(".navbar-toggler"), document.getElementById("main-content")].find(
          isVisibleSearchTarget
        );
  await customElements.whenDefined("ninja-keys");
  ninjaKeys.open();
};
const toggleSearchModal = () => {
  if (ninjaKeys?.visible) ninjaKeys.close();
  else openSearchModal();
};
