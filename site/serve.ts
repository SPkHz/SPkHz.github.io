const root = new URL("../", import.meta.url);
const siteDir = new URL("./_site_deno/", root);
export const DEFAULT_HOSTNAME = "127.0.0.1";

const contentTypes: Record<string, string> = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".webp": "image/webp",
  ".ico": "image/x-icon",
  ".txt": "text/plain; charset=utf-8",
  ".md": "text/markdown; charset=utf-8",
};

function extname(path: string): string {
  const last = path.split("/").pop() ?? "";
  const index = last.lastIndexOf(".");
  return index >= 0 ? last.slice(index).toLowerCase() : "";
}

export function safeRelativePath(pathname: string): string | null {
  const parts = decodeURIComponent(pathname).split("/").filter(Boolean);
  if (parts.some((part) => part === ".." || part.includes("\0"))) return null;
  return parts.length === 0 ? "index.html" : parts.join("/");
}

export async function handler(request: Request): Promise<Response> {
  const relative = safeRelativePath(new URL(request.url).pathname);
  if (relative === null) return new Response("Bad request", { status: 400 });

  let fileUrl = new URL(relative, siteDir);
  try {
    const info = await Deno.stat(fileUrl);
    if (info.isDirectory) {
      fileUrl = new URL("index.html", new URL(`${relative}/`, siteDir));
    }
    const body = await Deno.readFile(fileUrl);
    return new Response(body, {
      headers: {
        "content-type": contentTypes[extname(fileUrl.pathname)] ??
          "application/octet-stream",
      },
    });
  } catch {
    return new Response("Not found", { status: 404 });
  }
}

if (import.meta.main) {
  const port = Number(Deno.env.get("PORT") ?? "8080");

  try {
    await Deno.stat(siteDir);
  } catch {
    console.error(`Missing ${siteDir.pathname}; run deno task build first.`);
    Deno.exit(1);
  }

  Deno.serve(
    { hostname: DEFAULT_HOSTNAME, port },
    handler,
  );
}
