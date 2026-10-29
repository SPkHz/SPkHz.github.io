#!/usr/bin/env python3
"""Run the lock-owned axe CLI against one bounded loopback HTTP server."""

import argparse
import json
import os
import shutil
import signal
import socket
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import quote, urlsplit

SAFE_ENVIRONMENT = ("LANG", "LC_ALL", "PATH", "TMPDIR", "TZ")
CHROME_OPTIONS = (
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
)


class RunnerError(RuntimeError):
    """The bounded axe run cannot proceed safely."""


def directory(path, label):
    resolved = path.resolve(strict=True)
    if not resolved.is_dir():
        raise RunnerError(f"{label} is not a directory: {path}")
    return resolved


def file(path, label, executable=False):
    resolved = path.resolve(strict=True)
    if not resolved.is_file():
        raise RunnerError(f"{label} is not a regular file: {path}")
    if executable and not os.access(resolved, os.X_OK):
        raise RunnerError(f"{label} is not executable: {path}")
    return resolved


def owned_directory(path):
    if path.is_symlink():
        raise RunnerError(f"owned directory must not be a symlink: {path}")
    path.mkdir(parents=True, exist_ok=True, mode=0o700)
    if path.is_symlink() or not path.is_dir():
        raise RunnerError(f"owned directory is invalid: {path}")
    os.chmod(path, 0o700)
    return path.resolve()


def target_url(target, port):
    if any(ord(character) < 32 for character in target) or "\\" in target:
        raise RunnerError("target must be a relative target path")
    parsed = urlsplit(target)
    if parsed.scheme or parsed.netloc or target.startswith("//"):
        raise RunnerError("target must be a relative target path")
    parts = [part for part in parsed.path.split("/") if part]
    if any(part in (".", "..") for part in parts):
        raise RunnerError("target must be a relative target path")
    normalized = quote(parsed.path.lstrip("/"), safe="/-._~")
    if parsed.query:
        normalized = f"{normalized}?{quote(parsed.query, safe='=&%-._~')}"
    return f"http://127.0.0.1:{port}/{normalized}"


def sanitized_environment(state_dir):
    environment = {
        key: os.environ[key] for key in SAFE_ENVIRONMENT if key in os.environ
    }
    home = owned_directory(state_dir / "home")
    config = owned_directory(state_dir / "xdg-config")
    cache = owned_directory(state_dir / "xdg-cache")
    environment.update(
        {
            "HOME": str(home),
            "XDG_CONFIG_HOME": str(config),
            "XDG_CACHE_HOME": str(cache),
            "NO_UPDATE_NOTIFIER": "1",
        }
    )
    dotenv = home / ".browser-driver-manager" / ".env"
    if dotenv.exists() or dotenv.is_symlink():
        raise RunnerError("sanitized browser-driver-manager dotenv path is not absent")
    return environment


def group_exists(process_group):
    try:
        os.killpg(process_group, 0)
    except ProcessLookupError:
        return False
    return True


def stop_group(process, process_group, timeout=5.0):
    if not group_exists(process_group):
        process.wait(timeout=timeout)
        return
    os.killpg(process_group, signal.SIGTERM)
    try:
        process.wait(timeout=timeout)
    except subprocess.TimeoutExpired:
        if group_exists(process_group):
            os.killpg(process_group, signal.SIGKILL)
        try:
            process.wait(timeout=timeout)
        except subprocess.TimeoutExpired as error:
            raise RunnerError(
                f"owned process group {process_group} did not exit"
            ) from error
    if group_exists(process_group):
        os.killpg(process_group, signal.SIGKILL)


def wait_for_server(process, port, timeout):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if process.poll() is not None:
            raise RunnerError(f"HTTP server exited {process.returncode} during startup")
        try:
            with socket.create_connection(("127.0.0.1", port), timeout=0.2):
                return
        except OSError:
            time.sleep(0.05)
    raise RunnerError(f"HTTP server did not bind loopback port {port} in time")


def utc_now():
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def atomic_json(path, payload):
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.", suffix=".tmp", dir=path.parent
    )
    temporary = Path(temporary_name)
    os.fchmod(descriptor, 0o600)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as output:
            json.dump(payload, output, indent=2, sort_keys=True)
            output.write("\n")
            output.flush()
            os.fsync(output.fileno())
        os.replace(temporary, path)
    except Exception:
        print(f"preserved failed result at {temporary}", file=sys.stderr)
        raise


def run(args):
    if not 1 <= args.port <= 65535:
        raise RunnerError("port is outside the valid range")
    site = directory(args.site_dir, "site directory")
    chrome = file(args.chrome, "Chrome", executable=True)
    chromedriver = file(args.chromedriver, "ChromeDriver", executable=True)
    axe_source = file(args.axe_source, "axe source")
    http_server = file(args.http_server, "http-server", executable=True)
    axe = file(args.axe, "axe", executable=True)
    state = owned_directory(args.state_dir)
    diagnostics = owned_directory(args.diagnostics_dir)
    result_json = args.result_json.absolute()
    if result_json.exists() or result_json.is_symlink():
        raise RunnerError(f"result JSON already exists: {result_json}")
    if result_json.parent.resolve(strict=True) != diagnostics:
        raise RunnerError("result JSON must be directly inside the diagnostics directory")
    url = target_url(args.target_path, args.port)
    environment = sanitized_environment(state)
    node_name = shutil.which("node", path=environment.get("PATH", ""))
    if node_name is None:
        raise RunnerError("Node executable is unavailable in the admitted PATH")
    node = file(Path(node_name), "Node", executable=True)
    adapter = file(Path(__file__).with_name("axe-cli-entry.cjs"), "axe CLI adapter")
    request = {
        "axe": str(axe),
        "url": url,
        "chromePath": str(chrome),
        "chromedriverPath": str(chromedriver),
        "axeSource": str(axe_source),
        "chromeOptions": list(CHROME_OPTIONS),
    }

    server_stdout = (diagnostics / "http-server.stdout.log").open("wb")
    server_stderr = (diagnostics / "http-server.stderr.log").open("wb")
    axe_stdout = (diagnostics / "axe.stdout.log").open("wb")
    axe_stderr = (diagnostics / "axe.stderr.log").open("wb")
    for stream in (server_stdout, server_stderr, axe_stdout, axe_stderr):
        os.chmod(stream.name, 0o600)

    server = None
    server_group = None
    axe_process = None
    axe_group = None
    axe_returncode = 1
    operation_error = None
    cleanup_errors = []
    receipt = {
        "schema_version": 1,
        "started_at_utc": utc_now(),
        "finished_at_utc": None,
        "status": "started",
        "error": None,
        "site_dir": str(site),
        "target_url": url,
        "chrome_path": str(chrome),
        "chromedriver_path": str(chromedriver),
        "axe_source": str(axe_source),
        "chrome_options": CHROME_OPTIONS,
        "node_path": str(node),
        "adapter_path": str(adapter),
        "server": {
            "executable": str(http_server),
            "pid": None,
            "process_group": None,
            "exit_code": None,
        },
        "axe": {
            "executable": str(axe),
            "pid": None,
            "process_group": None,
            "exit_code": None,
        },
    }
    try:
        server = subprocess.Popen(
            [
                str(http_server),
                str(site),
                "-a",
                "127.0.0.1",
                "-p",
                str(args.port),
                "-c-1",
                "--silent",
            ],
            env=environment,
            stdin=subprocess.DEVNULL,
            stdout=server_stdout,
            stderr=server_stderr,
            start_new_session=True,
        )
        server_group = server.pid
        receipt["server"]["pid"] = server.pid
        receipt["server"]["process_group"] = server_group
        wait_for_server(server, args.port, args.startup_timeout)

        axe_process = subprocess.Popen(
            [
                str(node),
                str(adapter),
                json.dumps(request),
            ],
            env=environment,
            stdin=subprocess.DEVNULL,
            stdout=axe_stdout,
            stderr=axe_stderr,
            start_new_session=True,
        )
        axe_group = axe_process.pid
        receipt["axe"]["pid"] = axe_process.pid
        receipt["axe"]["process_group"] = axe_group
        try:
            axe_returncode = axe_process.wait(timeout=args.axe_timeout)
        except subprocess.TimeoutExpired as error:
            raise RunnerError(f"axe exceeded {args.axe_timeout} seconds") from error
    except (OSError, RunnerError) as error:
        operation_error = error
    finally:
        for label, process, process_group in (
            ("axe", axe_process, axe_group),
            ("server", server, server_group),
        ):
            if process is None or process_group is None:
                continue
            try:
                stop_group(process, process_group)
            except (OSError, RunnerError) as error:
                cleanup_errors.append(f"{label}: {error}")
            receipt[label]["exit_code"] = process.poll()
        for stream in (server_stdout, server_stderr, axe_stdout, axe_stderr):
            stream.close()
        receipt["finished_at_utc"] = utc_now()
        if operation_error is not None:
            receipt["status"] = "runner_error"
            receipt["error"] = str(operation_error)
        elif cleanup_errors:
            receipt["status"] = "cleanup_error"
            receipt["error"] = "; ".join(cleanup_errors)
        elif axe_returncode == 0:
            receipt["status"] = "passed"
        else:
            receipt["status"] = "axe_failed"
        atomic_json(result_json, receipt)
    if operation_error is not None:
        raise operation_error
    if cleanup_errors:
        raise RunnerError("; ".join(cleanup_errors))
    return axe_returncode


def parser():
    command = argparse.ArgumentParser()
    command.add_argument("--site-dir", type=Path, required=True)
    command.add_argument("--target-path", default="")
    command.add_argument("--chrome", type=Path, required=True)
    command.add_argument("--chromedriver", type=Path, required=True)
    command.add_argument("--axe-source", type=Path, required=True)
    command.add_argument("--http-server", type=Path, required=True)
    command.add_argument("--axe", type=Path, required=True)
    command.add_argument("--state-dir", type=Path, required=True)
    command.add_argument("--diagnostics-dir", type=Path, required=True)
    command.add_argument("--result-json", type=Path, required=True)
    command.add_argument("--port", type=int, default=8080)
    command.add_argument("--startup-timeout", type=float, default=30.0)
    command.add_argument("--axe-timeout", type=float, default=300.0)
    return command


def main():
    try:
        return run(parser().parse_args())
    except (OSError, RunnerError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
