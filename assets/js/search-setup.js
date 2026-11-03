const ninjaKeys = document.querySelector("ninja-keys");
ninjaKeys?.classList.toggle("dark", determineComputedTheme() === "dark");
const openSearchModal = () => {
  window.SiteUI?.closeNavigation();
  ninjaKeys?.open();
};
