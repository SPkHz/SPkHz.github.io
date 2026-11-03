// Browser regression checks. Supply an independently installed Playwright module.
// PLAYWRIGHT_MODULE=/path/to/playwright/index.mjs node tests/browser/runtime.mjs URL
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
const { chromium } = await import(process.env.PLAYWRIGHT_MODULE || "playwright");
const base = process.argv[2];
assert.ok(base, "Supply the local preview URL");
const browser = await chromium.launch({ headless: true });
const failures = [];
async function check(name, fn) {
  try {
    await fn();
    console.log(`PASS ${name}`);
  } catch (error) {
    failures.push(name);
    console.error(`FAIL ${name}: ${error.message}`);
  }
}
try {
  await check("menu API, Escape focus and search coordination", async () => {
    const page = await browser.newPage({ viewport: { width: 390, height: 844 } });
    await page.goto(base);
    assert.equal(await page.evaluate(() => typeof window.SiteUI?.closeNavigation), "function");
    await page.locator(".navbar-toggler").click();
    assert.equal(await page.locator(".navbar-toggler").getAttribute("aria-expanded"), "true");
    await page.keyboard.press("Escape");
    assert.equal(await page.locator(".navbar-toggler").getAttribute("aria-expanded"), "false");
    assert.equal(await page.evaluate(() => document.activeElement.matches(".navbar-toggler")), true);
    await page.locator(".navbar-toggler").click();
    await page.locator("#search-toggle").click();
    assert.equal(await page.locator(".navbar-toggler").getAttribute("aria-expanded"), "false");
    await page.locator("ninja-keys").locator("input").waitFor({ state: "visible" });
    await page.close();
  });
  await check("manual theme selection survives unavailable storage", async () => {
    const context = await browser.newContext();
    await context.addInitScript(() => {
      Object.defineProperty(window, "localStorage", {
        get() {
          throw new DOMException("blocked", "SecurityError");
        },
      });
    });
    const page = await context.newPage();
    await page.goto(base);
    await page.locator("#light-toggle").click();
    assert.equal(await page.locator("html").getAttribute("data-theme-setting"), "light");
    await page.locator("#light-toggle").click();
    assert.equal(await page.locator("html").getAttribute("data-theme"), "dark");
    await page.locator("#light-toggle").click();
    assert.equal(await page.locator("html").getAttribute("data-theme-setting"), "system");
    await context.close();
  });
  await check("image errors affect only their own picture", async () => {
    const page = await browser.newPage();
    await page.goto(base);
    const counts = await page.evaluate(() => {
      const original = document.querySelector("picture img[onerror]");
      const holder = document.createElement("div");
      holder.innerHTML =
        '<picture><source class="responsive-img-srcset"><img></picture><picture><source class="responsive-img-srcset"><img></picture>';
      document.body.append(holder);
      holder.querySelector("img").onerror = original.onerror;
      holder.querySelector("img").dispatchEvent(new Event("error"));
      return [...holder.children].map((picture) => picture.querySelectorAll("source").length);
    });
    assert.deepEqual(counts, [0, 1]);
    await page.close();
  });
  await check("bibliography disclosures work with keyboard and without JavaScript", async () => {
    // Render the real common initializer against a small bibliography fixture.
    const page = await browser.newPage();
    await page.goto(base);
    const script = await readFile(new URL("../../assets/js/common.js", import.meta.url), "utf8");
    await page.setContent(
      '<ol class="bibliography"><li><div><div class="links"><button class="abstract">Abs</button><button class="bibtex">Bib</button></div><div class="abstract hidden">Abstract text</div><div class="bibtex hidden">Citation text</div></div></li></ol>'
    );
    await page.addScriptTag({ content: script });
    // The helper must initialize on documents already loaded as well as deferred load.
    await page.locator("button.abstract").focus();
    await page.keyboard.press("Enter");
    assert.equal(await page.locator("button.abstract").getAttribute("aria-expanded"), "true");
    await page.locator("button.bibtex").click();
    assert.equal(await page.locator("button.abstract").getAttribute("aria-expanded"), "false");
    assert.equal(await page.locator("button.bibtex").getAttribute("aria-expanded"), "true");
    await page.close();
  });
  await check("sidebar links target headings and track the current section", async () => {
    const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
    await page.goto(new URL("/projects/ee322_lab_02_ic_biasing_techniques/", base).href);
    const links = page.locator('#toc-sidebar a[href^="#"]');
    assert.ok((await links.count()) > 2);
    const link = links.nth(2);
    await link.click();
    await page.waitForFunction(() => document.querySelector('#toc-sidebar a[aria-current="location"]')?.hash === location.hash);
    await page.close();
  });
  await check("back-to-top is keyboard operable and progress reflects scrolling", async () => {
    const page = await browser.newPage({ reducedMotion: "reduce" });
    await page.goto(new URL("/projects/", base).href);
    await page.evaluate(() => window.scrollTo(0, 1000));
    const control = page.locator("#back-to-top");
    await control.waitFor({ state: "visible" });
    assert.equal(await control.evaluate((el) => el.tagName), "BUTTON");
    assert.ok(Number(await page.locator("#progress").getAttribute("value")) > 0);
    await control.focus();
    await page.keyboard.press("Enter");
    await page.waitForFunction(() => window.scrollY === 0);
    await page.close();
  });
  await check("document navigation and tab contents remain usable without JavaScript", async () => {
    const context = await browser.newContext({ javaScriptEnabled: false, viewport: { width: 390, height: 844 } });
    const page = await context.newPage();
    await page.goto(base);
    assert.equal(await page.locator('#navbarNav a[href="/projects/"]').isVisible(), true);
    await page.locator('#navbarNav a[href="/projects/"]').click();
    assert.equal(new URL(page.url()).pathname, "/projects/");
    await page.goto(new URL("/projects/ee319_lab_02_active_band_pass_filter/", base).href);
    const panels = page.locator("ul.tab-content > li");
    assert.ok((await panels.count()) > 1);
    for (const panel of await panels.all()) assert.equal(await panel.isVisible(), true);
    await context.close();
  });
} finally {
  await browser.close();
}
if (failures.length) process.exitCode = 1;
