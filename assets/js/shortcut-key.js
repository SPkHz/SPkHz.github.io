// Own the search shortcut so both keyboard and pointer openers close navigation.
document.addEventListener(
  "keydown",
  (event) => {
    if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "k") {
      event.preventDefault();
      event.stopImmediatePropagation();
      openSearchModal();
    }
  },
  true
);
document.addEventListener("DOMContentLoaded", () => {
  const shortcut = document.querySelector("#search-toggle kbd");
  if (shortcut && /MAC/i.test(navigator.platform)) shortcut.textContent = "⌘ k";
});
