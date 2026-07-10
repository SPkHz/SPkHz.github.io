const root = new URL("../", import.meta.url);
const outDir = new URL("./_site_deno/", root);

async function exists(path: URL): Promise<boolean> {
  try {
    await Deno.stat(path);
    return true;
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) return false;
    throw error;
  }
}

async function emptyDir(path: URL): Promise<void> {
  await Deno.remove(path, { recursive: true }).catch((error) => {
    if (!(error instanceof Deno.errors.NotFound)) throw error;
  });
  await Deno.mkdir(path, { recursive: true });
}

function child(base: URL, name: string, isDirectory = false): URL {
  return new URL(`${encodeURIComponent(name)}${isDirectory ? "/" : ""}`, base);
}

async function copyTree(from: URL, to: URL): Promise<void> {
  const info = await Deno.stat(from);
  if (info.isDirectory) {
    await Deno.mkdir(to, { recursive: true });
    for await (const entry of Deno.readDir(from)) {
      if (entry.name.startsWith(".")) continue;
      if (entry.name.toLowerCase().includes("secret")) continue;
      await copyTree(
        child(from, entry.name, entry.isDirectory),
        child(to, entry.name, entry.isDirectory),
      );
    }
  } else if (info.isFile) {
    await Deno.copyFile(from, to);
  }
}

async function collectMarkdownPages(): Promise<string[]> {
  const dirs = ["_pages", "_posts", "_projects", "_news"];
  const pages: string[] = [];
  for (const dir of dirs) {
    const url = new URL(`./${dir}/`, root);
    if (!(await exists(url))) continue;
    for await (const entry of Deno.readDir(url)) {
      if (entry.isFile && entry.name.endsWith(".md")) {
        pages.push(`${dir}/${entry.name}`);
      }
    }
  }
  return pages.sort().slice(0, 80);
}

function htmlEscape(value: string): string {
  return value.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(
    ">",
    "&gt;",
  );
}

await emptyDir(outDir);

for (const dir of ["assets", "readme_preview"]) {
  const source = new URL(`./${dir}/`, root);
  if (await exists(source)) {
    await copyTree(source, new URL(`./${dir}/`, outDir));
  }
}

for (const file of ["robots.txt", "README.md", "FAQ.md"]) {
  const source = new URL(`./${file}`, root);
  if (await exists(source)) {
    await Deno.copyFile(source, new URL(`./${file}`, outDir));
  }
}

const pages = await collectMarkdownPages();
const pageLinks = pages.map((page) => `<li>${htmlEscape(page)}</li>`).join(
  "\n",
);

await Deno.writeTextFile(
  new URL("./index.html", outDir),
  `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SPkHz static Deno preview</title>
    <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
  </head>
  <body>
    <main style="max-width: 920px; margin: 0 auto; padding: 40px 20px; font-family: system-ui, sans-serif;">
      <h1>SPkHz static Deno preview</h1>
      <p>This Deno-owned workflow preserves the Jekyll/Ruby metadata in the source root and builds a static preview from public assets and source page listings without invoking Node, npm, Ruby, or Jekyll.</p>
      <h2>Source pages represented</h2>
      <ul>${pageLinks}</ul>
    </main>
  </body>
</html>
`,
);

console.log(`built ${outDir.pathname}`);
