"""Test the bounded loopback axe runner without starting a real browser."""

import json
import os
import shutil
import socket
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RUNNER = ROOT / ".github" / "ci-tools" / "run-axe.py"


class AxeRunnerTest(unittest.TestCase):
    def executable(self, path, body):
        path.write_text(f"#!{sys.executable}\n{body}")
        path.chmod(0o755)

    def fixture(self, root, axe_exit=0):
        site = root / "site"
        site.mkdir()
        (site / "index.html").write_text("<!doctype html><title>fixture</title>")
        tools = root / "tools"
        tools.mkdir()
        server_record = root / "server.json"
        axe_record = root / "axe.json"
        self.executable(
            tools / "http-server",
            f"""
import http.server
import json
import os
from pathlib import Path
import socketserver
import sys
root = Path(sys.argv[1])
host = sys.argv[sys.argv.index("-a") + 1]
port = int(sys.argv[sys.argv.index("-p") + 1])
Path({str(server_record)!r}).write_text(json.dumps({{"pid": os.getpid(), "argv": sys.argv[1:]}}))
handler = lambda *args, **kwargs: http.server.SimpleHTTPRequestHandler(*args, directory=str(root), **kwargs)
with socketserver.TCPServer((host, port), handler) as server:
    server.serve_forever()
""",
        )
        self.executable(
            tools / "axe",
            f"""
import json
import os
from pathlib import Path
import sys
keys = ["HOME", "SSH_AUTH_SOCK", "CHROME_TEST_PATH", "CHROMEDRIVER_TEST_PATH", "GITHUB_TOKEN"]
Path({str(axe_record)!r}).write_text(json.dumps({{"argv": sys.argv[1:], "env": {{key: os.environ.get(key) for key in keys}}}}))
sys.exit({axe_exit})
""",
        )
        self.executable(
            tools / "node",
            f"""
import json
import os
from pathlib import Path
import sys
keys = ["HOME", "SSH_AUTH_SOCK", "CHROME_TEST_PATH", "CHROMEDRIVER_TEST_PATH", "GITHUB_TOKEN"]
request = json.loads(sys.argv[2])
Path({str(axe_record)!r}).write_text(json.dumps({{"request": request, "adapter": sys.argv[1], "env": {{key: os.environ.get(key) for key in keys}}}}))
sys.exit({axe_exit})
""",
        )
        for name in ("chrome", "chromedriver"):
            self.executable(tools / name, "pass\n")
        axe_source = root / "axe.min.js"
        axe_source.write_text("/* synthetic axe source */")
        return site, tools, axe_source, server_record, axe_record

    def free_port(self):
        with socket.socket() as sock:
            sock.bind(("127.0.0.1", 0))
            return sock.getsockname()[1]

    def run_runner(self, root, site, tools, axe_source, server_record, axe_record, target="docs/"):
        port = self.free_port()
        env = {
            "PATH": str(tools) + os.pathsep + os.environ.get("PATH", ""),
            "LANG": "C.UTF-8",
            "SSH_AUTH_SOCK": "/forbidden/signing-agent",
            "CHROME_TEST_PATH": "/forbidden/chrome",
            "CHROMEDRIVER_TEST_PATH": "/forbidden/chromedriver",
            "GITHUB_TOKEN": "synthetic-secret",
        }
        result = subprocess.run(
            [
                sys.executable,
                str(RUNNER),
                "--site-dir",
                str(site),
                "--target-path",
                target,
                "--chrome",
                str(tools / "chrome"),
                "--chromedriver",
                str(tools / "chromedriver"),
                "--axe-source",
                str(axe_source),
                "--http-server",
                str(tools / "http-server"),
                "--axe",
                str(tools / "axe"),
                "--state-dir",
                str(root / "state"),
                "--diagnostics-dir",
                str(root / "diagnostics"),
                "--result-json",
                str(root / "diagnostics" / "axe-run.json"),
                "--port",
                str(port),
                "--startup-timeout",
                "5",
                "--axe-timeout",
                "5",
            ],
            check=False,
            env=env,
            capture_output=True,
            text=True,
            timeout=15,
        )
        return result

    def assert_server_stopped(self, record):
        pid = json.loads(record.read_text())["pid"]
        for _ in range(30):
            try:
                os.kill(pid, 0)
            except ProcessLookupError:
                return
            time.sleep(0.05)
        self.fail(f"owned HTTP server process {pid} is still running")

    def test_explicit_artifacts_sanitized_environment_and_owned_cleanup(self):
        self.assertTrue(RUNNER.is_file(), "bounded axe runner is missing")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            fixture = self.fixture(root)
            result = self.run_runner(root, *fixture)

            self.assertEqual(result.returncode, 0, result.stderr)
            _site, tools, axe_source, server_record, axe_record = fixture
            record = json.loads(axe_record.read_text())
            self.assertIn("request", record, "runner must preserve structured options")
            request = record["request"]
            self.assertEqual(request["chromePath"], str(tools / "chrome"))
            self.assertEqual(request["chromedriverPath"], str(tools / "chromedriver"))
            self.assertEqual(request["axeSource"], str(axe_source))
            self.assertEqual(request["axe"], str(tools / "axe"))
            self.assertTrue(record["adapter"].endswith("/axe-cli-entry.cjs"))
            chrome_options = request["chromeOptions"]
            self.assertIsInstance(chrome_options, list)
            self.assertIn("host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE 127.0.0.1", chrome_options)
            self.assertEqual(sum(x.startswith("host-resolver-rules=") for x in chrome_options), 1)
            self.assertIn("disable-background-networking", chrome_options)
            self.assertIn("disable-quic", chrome_options)
            self.assertIn("proxy-server=http://127.0.0.1:9", chrome_options)
            self.assertIn("proxy-bypass-list=127.0.0.1", chrome_options)
            self.assertNotIn("no-sandbox", chrome_options)
            self.assertTrue(request["url"].startswith("http://127.0.0.1:"))
            self.assertEqual(record["env"]["HOME"], str(root / "state" / "home"))
            for key in ("SSH_AUTH_SOCK", "CHROME_TEST_PATH", "CHROMEDRIVER_TEST_PATH", "GITHUB_TOKEN"):
                self.assertIsNone(record["env"][key])
            self.assertFalse((root / "state" / "home" / ".browser-driver-manager" / ".env").exists())
            receipt_path = root / "diagnostics" / "axe-run.json"
            receipt = json.loads(receipt_path.read_text())
            self.assertEqual(receipt["status"], "passed")
            self.assertEqual(receipt["axe"]["exit_code"], 0)
            self.assertEqual(receipt["server"]["pid"], json.loads(server_record.read_text())["pid"])
            self.assertIsInstance(receipt["server"]["exit_code"], int)
            self.assertEqual(receipt_path.stat().st_mode & 0o777, 0o600)
            self.assert_server_stopped(server_record)

    def test_axe_failure_propagates_and_still_stops_owned_server(self):
        self.assertTrue(RUNNER.is_file(), "bounded axe runner is missing")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            fixture = self.fixture(root, axe_exit=7)
            result = self.run_runner(root, *fixture)

            self.assertEqual(result.returncode, 7)
            receipt = json.loads((root / "diagnostics" / "axe-run.json").read_text())
            self.assertEqual(receipt["status"], "axe_failed")
            self.assertEqual(receipt["axe"]["exit_code"], 7)
            self.assert_server_stopped(fixture[3])

    def test_external_target_is_rejected_before_server_start(self):
        self.assertTrue(RUNNER.is_file(), "bounded axe runner is missing")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            fixture = self.fixture(root)
            result = self.run_runner(root, *fixture, target="https://example.invalid/")

            self.assertNotEqual(result.returncode, 0)
            self.assertIn("relative target path", result.stderr)
            self.assertFalse(fixture[3].exists())



class AxeAdapterTest(unittest.TestCase):
    def package(self):
        fallback = ROOT / ".github/ci-tools/node_modules/@axe-core/cli"
        package = Path(os.environ.get("AXE_CLI_TEST_PACKAGE", str(fallback))).resolve()
        self.assertTrue((package / "package.json").is_file(), "exact installed axe CLI fixture is required")
        return package

    def request(self, root, package):
        import importlib.util
        spec = importlib.util.spec_from_file_location("axe_runner_under_test", RUNNER)
        runner = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(runner)
        for name in ("chrome", "chromedriver"):
            path = root / name
            path.write_text("inert test artifact; must never execute\n")
            path.chmod(0o700)
        return {
            "axe": str(package / "dist/src/bin/cli.js"),
            "url": "http://127.0.0.1:8765/fixture/",
            "chromePath": str(root / "chrome"),
            "chromedriverPath": str(root / "chromedriver"),
            "axeSource": str(package.parents[1] / "axe-core/axe.js"),
            "chromeOptions": list(runner.CHROME_OPTIONS),
        }

    def invoke(self, root, package, request, mode="pass"):
        adapter = RUNNER.with_name("axe-cli-entry.cjs")
        self.assertTrue(adapter.is_file(), "structured CLI adapter is missing")
        capture = root / (mode + ".json")
        preload = root / (mode + ".cjs")
        preload.write_text(
            "const root = " + json.dumps(str(package)) + ";\n"
            "const capture = " + json.dumps(str(capture)) + ";\n"
            "const mode = " + json.dumps(mode) + ";\n" + r"""
const path = require('node:path');
const fs = require('node:fs');
const cp = require('node:child_process');
for (const name of ['spawn', 'spawnSync', 'exec', 'execSync', 'execFile', 'execFileSync', 'fork']) {
  cp[name] = () => { throw new Error('real subprocess forbidden in adapter fixture'); };
}
const {createRequire} = require('node:module');
const local = createRequire(path.join(root, 'package.json'));
const selenium = local('selenium-webdriver');
const chrome = local('selenium-webdriver/chrome');
const record = {};
const OriginalService = chrome.ServiceBuilder;
chrome.ServiceBuilder = class extends OriginalService {
  constructor(executable) { super(executable); record.driverPath = executable; }
};
selenium.Builder.prototype.build = function () {
  record.chromeOptions = this.getChromeOptions().get('goog:chromeOptions');
  return {manage: () => ({setTimeouts: async value => {record.timeouts = value;}})};
};
const filename = path.join(root, 'dist/src/lib/axe-test-urls.js');
require.cache[filename] = {id: filename, filename, loaded: true, exports: {
  __esModule: true,
  default: async (urls, params) => {
    await params.driver;
    record.urls = urls;
    record.loadDelay = params.loadDelay;
    record.scope = [params.include, params.exclude, params.tags, params.rules, params.disable];
    fs.writeFileSync(capture, JSON.stringify(record));
    if (mode === 'error') throw new Error('controlled fixture navigation error');
    return [{violations: mode === 'violation' ? [{id: 'fixture-rule'}] : []}];
  },
}};
"""
        )
        node = os.environ.get("BROWSER_TEST_NODE") or shutil.which("node")
        self.assertTrue(node, "Node is required for the exact CLI adapter contract")
        home = root / (mode + "-home")
        home.mkdir()
        result = subprocess.run(
            [node, "--require", str(preload), str(adapter), json.dumps(request)],
            check=False,
            env={"PATH": os.path.dirname(node) + os.pathsep + "/usr/bin:/bin", "HOME": str(home), "LANG": "C.UTF-8"},
            capture_output=True, text=True, timeout=20,
        )
        return result, capture

    def test_real_cli_keeps_options_reporting_exit_and_error_semantics(self):
        package = self.package()
        for mode, expected in (("pass", 0), ("violation", 1), ("error", 1)):
            with self.subTest(mode=mode), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                request = self.request(root, package)
                result, capture = self.invoke(root, package, request, mode)
                self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
                self.assertTrue(capture.exists(), result.stderr)
                observed = json.loads(capture.read_text())
                args = observed["chromeOptions"]["args"]
                self.assertEqual([x for x in args if x.startswith("host-resolver-rules=")], ["host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE 127.0.0.1"])
                self.assertNotIn("no-sandbox", args)
                self.assertEqual(observed["chromeOptions"]["binary"], request["chromePath"])
                self.assertEqual(observed["driverPath"], request["chromedriverPath"])
                self.assertEqual(observed["urls"], ["http://127.0.0.1:8765/fixture/"])
                self.assertEqual(observed["loadDelay"], "1500")
                self.assertEqual(observed["timeouts"], {"script": 90000})
                self.assertEqual(observed["scope"], [None] * 5)
                self.assertIn("Running axe-core ", result.stdout)
                self.assertIn(" in chrome-headless", result.stdout)
                if mode == "error":
                    self.assertIn("controlled fixture navigation error", result.stderr)
                else:
                    self.assertIn("Testing complete of 1 pages", result.stdout)

    def test_adapter_rejects_external_target_or_widened_resolver(self):
        package = self.package()
        for key, value in (("url", "https://example.invalid/"), ("chromeOptions", ["no-sandbox"])):
            with self.subTest(key=key), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                request = self.request(root, package)
                request[key] = value
                result, capture = self.invoke(root, package, request)
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse(capture.exists())
                self.assertIn("invalid", result.stderr.lower())

    def test_changed_cli_entry_fails_before_module_execution(self):
        package = self.package()
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            request = self.request(root, package)
            clone = root / "cli"
            for relative in ("package.json", "dist/src/bin/cli.js", "dist/src/bin/index.js", "dist/src/lib/utils.js", "dist/src/lib/webdriver.js"):
                target = clone / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(package / relative, target)
            with (clone / "dist/src/bin/index.js").open("a") as stream:
                stream.write("\nthrow new Error('tampered code must not execute');\n")
            request["axe"] = str(clone / "dist/src/bin/cli.js")
            result, capture = self.invoke(root, package, request)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(capture.exists())
            self.assertIn("identity mismatch", result.stderr)
            self.assertNotIn("tampered code must not execute", result.stderr)


if __name__ == "__main__":
    unittest.main()
