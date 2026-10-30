#!/usr/bin/env python3
"""Fetch, verify, and extract the repository's exact Chrome-for-Testing pair."""

import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess
import sys
import tempfile
from urllib.parse import urlsplit
from urllib.request import Request, urlopen
import zipfile


ALLOWED_HOST = "storage.googleapis.com"
EXPECTED_PLATFORM = "linux64"
EXPECTED = {
    "chrome": ("chrome-linux64.zip", "chrome-linux64/chrome"),
    "chromedriver": (
        "chromedriver-linux64.zip",
        "chromedriver-linux64/chromedriver",
    ),
}
VERSION_RE = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")


class ArtifactError(RuntimeError):
    """A manifest, archive, extraction, or executable identity is invalid."""


def sha256_file(path):
    digest = hashlib.sha256()
    size = 0
    with path.open("rb") as source:
        while chunk := source.read(1024 * 1024):
            size += len(chunk)
            digest.update(chunk)
    return size, digest.hexdigest()


def load_manifest(path):
    raw = path.read_bytes()
    try:
        manifest = json.loads(raw)
    except json.JSONDecodeError as error:
        raise ArtifactError(f"invalid JSON manifest: {error}") from error
    if manifest.get("schema_version") != 1:
        raise ArtifactError("unsupported manifest schema")
    version = manifest.get("version")
    if not isinstance(version, str) or not VERSION_RE.fullmatch(version):
        raise ArtifactError("manifest has an invalid full version")
    if manifest.get("platform") != EXPECTED_PLATFORM:
        raise ArtifactError("manifest platform must be linux64")
    artifacts = manifest.get("artifacts")
    if not isinstance(artifacts, dict) or set(artifacts) != set(EXPECTED):
        raise ArtifactError("manifest must bind exactly Chrome and ChromeDriver")
    for name, (filename, executable) in EXPECTED.items():
        artifact = artifacts[name]
        if not isinstance(artifact, dict):
            raise ArtifactError(f"{name} artifact metadata is invalid")
        expected_url = (
            f"https://{ALLOWED_HOST}/chrome-for-testing-public/"
            f"{version}/{EXPECTED_PLATFORM}/{filename}"
        )
        if artifact.get("url") != expected_url:
            raise ArtifactError(f"{name} URL does not match the approved artifact")
        parts = urlsplit(artifact["url"])
        if parts.scheme != "https" or parts.hostname != ALLOWED_HOST:
            raise ArtifactError(f"{name} URL is not approved HTTPS")
        if artifact.get("filename") != filename:
            raise ArtifactError(f"{name} filename mismatch")
        if artifact.get("executable") != executable:
            raise ArtifactError(f"{name} executable path mismatch")
        if not isinstance(artifact.get("size_bytes"), int) or artifact["size_bytes"] <= 0:
            raise ArtifactError(f"{name} byte length is invalid")
        if not isinstance(artifact.get("sha256"), str) or not SHA256_RE.fullmatch(
            artifact["sha256"]
        ):
            raise ArtifactError(f"{name} SHA-256 is invalid")
        if artifact.get("publisher_checksum_available") is not False:
            raise ArtifactError(f"{name} checksum provenance must remain explicit")
    return manifest, hashlib.sha256(raw).hexdigest()


def verify_archive(path, artifact, name):
    size, digest = sha256_file(path)
    if size != artifact["size_bytes"]:
        raise ArtifactError(
            f"{name} byte-length mismatch: expected {artifact['size_bytes']}, got {size}"
        )
    if digest != artifact["sha256"]:
        raise ArtifactError(
            f"{name} SHA-256 mismatch: expected {artifact['sha256']}, got {digest}"
        )
    return {"size_bytes": size, "sha256": digest}


def fetch_archive(cache_dir, artifact, name, offline, timeout):
    cache_dir.mkdir(parents=True, exist_ok=True, mode=0o700)
    os.chmod(cache_dir, 0o700)
    destination = cache_dir / artifact["filename"]
    if destination.exists():
        if not destination.is_file() or destination.is_symlink():
            raise ArtifactError(f"{name} cache path is not a regular file")
        verify_archive(destination, artifact, name)
        return destination
    if offline:
        raise ArtifactError(f"{name} archive is absent in offline mode")

    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{artifact['filename']}.", suffix=".download", dir=cache_dir
    )
    temporary = Path(temporary_name)
    os.fchmod(descriptor, 0o600)
    try:
        request = Request(
            artifact["url"], headers={"User-Agent": "SPkHz-CI-artifact-verifier/1"}
        )
        with os.fdopen(descriptor, "wb") as output, urlopen(
            request, timeout=timeout
        ) as response:
            if response.geturl() != artifact["url"]:
                raise ArtifactError(f"{name} download redirected unexpectedly")
            remaining = artifact["size_bytes"] + 1
            while remaining:
                chunk = response.read(min(1024 * 1024, remaining))
                if not chunk:
                    break
                output.write(chunk)
                remaining -= len(chunk)
            output.flush()
            os.fsync(output.fileno())
        verify_archive(temporary, artifact, name)
        try:
            os.link(temporary, destination)
        except FileExistsError:
            verify_archive(destination, artifact, name)
        temporary.unlink()
        return destination
    except Exception:
        print(f"preserved failed {name} download at {temporary}", file=sys.stderr)
        raise


def safe_extract(archive_path, destination, expected_root):
    seen = set()
    with zipfile.ZipFile(archive_path) as archive:
        for info in archive.infolist():
            name = info.filename
            if "\\" in name or "\x00" in name:
                raise ArtifactError(f"unsafe ZIP member: {name!r}")
            relative = PurePosixPath(name)
            parts = relative.parts
            if (
                not parts
                or relative.is_absolute()
                or parts[0] != expected_root
                or any(part in ("", ".", "..") for part in parts)
            ):
                raise ArtifactError(f"unsafe ZIP member: {name!r}")
            mode = (info.external_attr >> 16) & 0xFFFF
            if stat.S_ISLNK(mode) or (
                mode and not stat.S_ISREG(mode) and not stat.S_ISDIR(mode)
            ):
                raise ArtifactError(f"unsupported ZIP member type: {name!r}")
            target = destination.joinpath(*parts)
            if target in seen and not info.is_dir():
                raise ArtifactError(f"duplicate ZIP member: {name!r}")
            seen.add(target)
            if info.is_dir():
                target.mkdir(parents=True, exist_ok=True, mode=0o755)
                continue
            target.parent.mkdir(parents=True, exist_ok=True, mode=0o755)
            if target.exists():
                raise ArtifactError(f"duplicate ZIP target: {name!r}")
            with archive.open(info) as source, target.open("xb") as output:
                while chunk := source.read(1024 * 1024):
                    output.write(chunk)
            permissions = mode & 0o777 if mode else 0o644
            os.chmod(target, permissions)


def executable_version(path, expected, label):
    if not path.is_file() or path.is_symlink() or not os.access(path, os.X_OK):
        raise ArtifactError(f"{label} executable is missing or invalid: {path}")
    try:
        result = subprocess.run(
            [str(path), "--version"],
            capture_output=True,
            text=True,
            timeout=15,
            check=False,
            env={"PATH": "/usr/bin:/bin", "LANG": "C.UTF-8", "HOME": "/nonexistent"},
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        raise ArtifactError(f"{label} version probe failed: {error}") from error
    observed = f"{result.stdout}\n{result.stderr}"
    if result.returncode != 0:
        raise ArtifactError(f"{label} version probe exited {result.returncode}")
    versions = re.findall(r"[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+", observed)
    if versions != [expected]:
        raise ArtifactError(
            f"{label} version mismatch: expected {expected}, observed {versions}"
        )
    return versions[0]


def atomic_json(path, payload):
    path.parent.mkdir(parents=True, exist_ok=True)
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
        print(f"preserved failed output at {temporary}", file=sys.stderr)
        raise


def prepare(args):
    manifest_path = args.manifest.resolve(strict=True)
    manifest, manifest_sha256 = load_manifest(manifest_path)
    archives = {}
    verified = {}
    for name in ("chrome", "chromedriver"):
        artifact = manifest["artifacts"][name]
        archive = fetch_archive(
            args.cache_dir, artifact, name, args.offline, args.download_timeout
        )
        archives[name] = archive
        verified[name] = verify_archive(archive, artifact, name)

    install_dir = args.install_dir.absolute()
    if install_dir.exists():
        raise ArtifactError(f"install destination already exists: {install_dir}")
    install_dir.parent.mkdir(parents=True, exist_ok=True)
    temporary = Path(
        tempfile.mkdtemp(prefix=f".{install_dir.name}.extract-", dir=install_dir.parent)
    )
    os.chmod(temporary, 0o700)
    try:
        safe_extract(archives["chrome"], temporary, "chrome-linux64")
        safe_extract(archives["chromedriver"], temporary, "chromedriver-linux64")
        chrome = temporary / EXPECTED["chrome"][1]
        chromedriver = temporary / EXPECTED["chromedriver"][1]
        chrome_version = executable_version(chrome, manifest["version"], "Chrome")
        driver_version = executable_version(
            chromedriver, manifest["version"], "ChromeDriver"
        )
        receipt = {
            "schema_version": 1,
            "manifest_sha256": manifest_sha256,
            "version": manifest["version"],
            "platform": manifest["platform"],
            "artifacts": verified,
        }
        atomic_json(temporary / ".cft-receipt.json", receipt)
        os.rename(temporary, install_dir)
    except Exception:
        print(f"preserved failed extraction at {temporary}", file=sys.stderr)
        raise

    result = {
        "schema_version": 1,
        "manifest_sha256": manifest_sha256,
        "version": manifest["version"],
        "platform": manifest["platform"],
        "chrome_path": str(install_dir / EXPECTED["chrome"][1]),
        "chromedriver_path": str(install_dir / EXPECTED["chromedriver"][1]),
        "chrome_version": chrome_version,
        "chromedriver_version": driver_version,
        "artifacts": verified,
    }
    atomic_json(args.output_json, result)
    if args.github_output:
        with args.github_output.open("a", encoding="utf-8") as output:
            output.write(f"chrome-path={result['chrome_path']}\n")
            output.write(f"chromedriver-path={result['chromedriver_path']}\n")
            output.write(f"chrome-version={result['chrome_version']}\n")
            output.write(f"chromedriver-version={result['chromedriver_version']}\n")
    return 0


def parser():
    command = argparse.ArgumentParser()
    subcommands = command.add_subparsers(dest="command", required=True)
    prepare_parser = subcommands.add_parser("prepare")
    prepare_parser.add_argument("--manifest", type=Path, required=True)
    prepare_parser.add_argument("--cache-dir", type=Path, required=True)
    prepare_parser.add_argument("--install-dir", type=Path, required=True)
    prepare_parser.add_argument("--output-json", type=Path, required=True)
    prepare_parser.add_argument("--github-output", type=Path)
    prepare_parser.add_argument("--offline", action="store_true")
    prepare_parser.add_argument("--download-timeout", type=float, default=60.0)
    prepare_parser.set_defaults(handler=prepare)
    return command


def main():
    args = parser().parse_args()
    try:
        return args.handler(args)
    except (ArtifactError, OSError, zipfile.BadZipFile) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
