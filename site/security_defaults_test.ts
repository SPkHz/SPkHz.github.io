const configUrl = new URL("../deno.json", import.meta.url);

const buildReadAllowlist =
  "--allow-read=./_pages,./_posts,./_projects,./_news,./assets,./readme_preview,./robots.txt,./README.md,./FAQ.md";

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) throw new Error(message);
}

function assertEquals<T>(actual: T, expected: T, message: string): void {
  if (actual !== expected) {
    throw new Error(
      `${message}: expected ${String(expected)}, got ${String(actual)}`,
    );
  }
}

async function readTasks(): Promise<Record<string, string>> {
  const config = JSON.parse(await Deno.readTextFile(configUrl)) as {
    tasks?: Record<string, string>;
  };
  assert(config.tasks, "deno.json must define tasks");
  return config.tasks;
}

function requireFlag(command: string, flag: string, task: string): void {
  assert(
    command.split(/\s+/).includes(flag),
    `${task} task must include ${flag}`,
  );
}

function rejectPermission(
  command: string,
  pattern: RegExp,
  task: string,
): void {
  assert(
    !pattern.test(command),
    `${task} task must not include forbidden permission matching ${pattern}`,
  );
}

Deno.test("Deno tasks use explicit minimal permissions", async () => {
  const tasks = await readTasks();
  const build = tasks.build ?? "";
  const serve = tasks.serve ?? "";
  const test = tasks.test ?? "";

  requireFlag(build, "--no-prompt", "build");
  requireFlag(build, buildReadAllowlist, "build");
  requireFlag(build, "--allow-write=./_site_deno", "build");

  requireFlag(serve, "--no-prompt", "serve");
  requireFlag(serve, "--allow-read=./_site_deno", "serve");
  requireFlag(serve, "--allow-env=PORT", "serve");
  requireFlag(serve, "--allow-net=127.0.0.1:8080", "serve");

  requireFlag(test, "--no-prompt", "test");

  const commands = Object.entries(tasks);
  for (const [task, command] of commands) {
    rejectPermission(command, /(?:^|\s)--allow-read=\.(?:\s|$)/, task);
    rejectPermission(command, /(?:^|\s)(?:-A|--allow-all)(?:\s|$)/, task);
    rejectPermission(command, /(?:^|\s)--allow-net(?:\s|$)/, task);
    rejectPermission(
      command,
      /(?:^|\s)--allow-net=0\.0\.0\.0(?::\d+)?(?:,|\s|$)/,
      task,
    );
    rejectPermission(
      command,
      /(?:^|\s)--allow-net=[^"\s]*(?:localhost|\*)(?:,|\s|$)/,
      task,
    );
    rejectPermission(
      command,
      /(?:^|\s)--allow-(?:run|ffi|sys)(?:[=\s]|$)/,
      task,
    );
  }
});

Deno.test("serve module imports without starting a listener", async () => {
  const server = await import("./serve.ts");

  assertEquals(
    server.DEFAULT_HOSTNAME,
    "127.0.0.1",
    "serve hostname must be explicit loopback",
  );
});

Deno.test("safeRelativePath rejects traversal", async () => {
  const { safeRelativePath } = await import("./serve.ts");

  assertEquals(safeRelativePath("/"), "index.html", "root path maps to index");
  assertEquals(
    safeRelativePath("/assets/site.css"),
    "assets/site.css",
    "normal path is preserved",
  );
  assertEquals(
    safeRelativePath("/../secrets/private.txt"),
    null,
    "literal traversal is rejected",
  );
  assertEquals(
    safeRelativePath("/%2e%2e/secrets/private.txt"),
    null,
    "encoded traversal is rejected",
  );
});
