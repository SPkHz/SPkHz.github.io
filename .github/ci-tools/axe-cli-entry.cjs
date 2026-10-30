"use strict";

// Preserve one Chrome argument per array item; axe's CLI comma parser is lossy.
// This internal entry is bound to the owning lock's exact package bytes.
const fs = require("node:fs");
const path = require("node:path");
const crypto = require("node:crypto");
const CLI_VERSION = "4.14.0";
const IDENTITIES = {
  "package.json": "87a4aa062d390a55735260956456d077e3dc4df2a7a18972297d12ced2b0b323",
  "dist/src/bin/cli.js": "523f510597f20b9438079f17c06a7810b1d9a2466f03345beecb20e0220ca64d",
  "dist/src/bin/index.js": "4c0e03a256964f610b379416e5a1c2b7b32d380937b4a2fcfebc6acfee96a93c",
  "dist/src/lib/utils.js": "461d748c23500d9b27f4384c38ebf1d458237195089704969de1479956dc7216",
  "dist/src/lib/webdriver.js": "54c500141619535409adc84cba21f161a58e648b2ecb0289af62efb7403b08d2",
};
const CHROME_OPTIONS = [
  "disable-background-networking",
  "disable-client-side-phishing-detection",
  "disable-component-update",
  "disable-domain-reliability",
  "disable-quic",
  "disable-sync",
  "host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE 127.0.0.1",
  "metrics-recording-only",
  "no-default-browser-check",
  "proxy-server=http://127.0.0.1:9",
  "proxy-bypass-list=127.0.0.1",
];

function regularFile(value) {
  if (typeof value !== "string" || !path.isAbsolute(value) || !fs.lstatSync(value).isFile()) {
    throw new Error("invalid regular file path");
  }
  return value;
}

async function main() {
  if (process.argv.length !== 3) throw new Error("invalid adapter argument count");
  const request = JSON.parse(process.argv[2]);
  const keys = ["axe", "url", "chromePath", "chromedriverPath", "axeSource", "chromeOptions"].sort();
  if (!request || JSON.stringify(Object.keys(request).sort()) !== JSON.stringify(keys)) {
    throw new Error("invalid adapter request fields");
  }
  if (typeof request.url !== "string" || !/^http:\/\/127\.0\.0\.1:[0-9]+\//.test(request.url) || /[\x00-\x20\x7f\\]/.test(request.url)) {
    throw new Error("invalid loopback URL");
  }
  const url = new URL(request.url);
  if (url.hostname !== "127.0.0.1" || url.username || url.password || url.hash) {
    throw new Error("invalid loopback URL");
  }
  if (JSON.stringify(request.chromeOptions) !== JSON.stringify(CHROME_OPTIONS)) {
    throw new Error("invalid Chrome options");
  }
  for (const key of ["axe", "chromePath", "chromedriverPath", "axeSource"]) regularFile(request[key]);
  const root = path.resolve(path.dirname(request.axe), "../../..");
  if (request.axe !== path.join(root, "dist/src/bin/cli.js")) throw new Error("invalid CLI layout");
  for (const [relative, expected] of Object.entries(IDENTITIES)) {
    const filename = regularFile(path.join(root, relative));
    const actual = crypto.createHash("sha256").update(fs.readFileSync(filename)).digest("hex");
    if (actual !== expected) throw new Error(`CLI identity mismatch: ${relative}`);
  }
  const metadata = JSON.parse(fs.readFileSync(path.join(root, "package.json"), "utf8"));
  if (metadata.name !== "@axe-core/cli" || metadata.version !== CLI_VERSION) {
    throw new Error("invalid CLI package identity");
  }
  const options = {
    chromePath: request.chromePath,
    chromedriverPath: request.chromedriverPath,
    axeSource: request.axeSource,
    chromeOptions: request.chromeOptions,
    loadDelay: "1500",
    timeout: "90",
    exit: true,
    reporter: true,
    showErrors: true,
  };
  const cli = require(path.join(root, "dist/src/bin/index.js")).default;
  await cli([request.url], options);
}

main().catch((error) => {
  console.error(`axe CLI adapter: ${error.message}`);
  process.exitCode = 1;
});
