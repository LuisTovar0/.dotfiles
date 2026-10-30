#!/usr/bin/env python3
"""Resolve a canonical OpenViking project URI across Git worktrees."""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
from pathlib import Path
from typing import Any


RESOURCE_ROOT = "viking://resources"


def run(command: list[str], cwd: Path) -> tuple[int, str, str]:
    try:
        process = subprocess.run(
            command,
            cwd=cwd,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            check=False,
        )
    except OSError as exc:
        return 127, "", str(exc)
    return process.returncode, process.stdout.strip(), process.stderr.strip()


def git(cwd: Path, *arguments: str) -> str | None:
    if shutil.which("git") is None:
        return None
    code, stdout, _ = run(["git", *arguments], cwd)
    return stdout if code == 0 and stdout else None


def normalize_name(value: str) -> str:
    value = value.strip().rstrip("/")
    prefix = f"{RESOURCE_ROOT}/"
    if value.casefold().startswith(prefix.casefold()):
        value = value[len(prefix) :].strip("/")
    if "/" in value or "\\" in value:
        raise ValueError("openviking.project must be a project name or a top-level resources URI")
    value = re.sub(r"\s+", "-", value)
    value = re.sub(r"[^A-Za-z0-9._-]+", "-", value).strip(".-")
    if not value:
        raise ValueError("could not derive a valid OpenViking project name")
    return value


def remote_name(remote: str) -> str:
    remote = remote.strip().rstrip("/").replace("\\", "/")
    tail = remote.rsplit("/", 1)[-1].rsplit(":", 1)[-1]
    if tail.casefold().endswith(".git"):
        tail = tail[:-4]
    return normalize_name(tail)


def resolve_common_dir(cwd: Path) -> Path | None:
    common = git(cwd, "rev-parse", "--path-format=absolute", "--git-common-dir")
    if common is None:
        common = git(cwd, "rev-parse", "--git-common-dir")
    if common is None:
        return None
    path = Path(common)
    if not path.is_absolute():
        path = (cwd / path).resolve()
    return path


def project_candidate(cwd: Path) -> tuple[str, str, dict[str, str | None]]:
    override = git(cwd, "config", "--get", "openviking.project")
    origin = git(cwd, "remote", "get-url", "origin")
    common_dir = resolve_common_dir(cwd)
    top_level = git(cwd, "rev-parse", "--show-toplevel")

    evidence: dict[str, str | None] = {
        "override": override,
        "origin": origin,
        "git_common_dir": str(common_dir) if common_dir else None,
        "git_top_level": top_level,
    }

    if override:
        return normalize_name(override), "git_config", evidence
    if origin:
        return remote_name(origin), "origin", evidence
    if common_dir:
        if common_dir.name == ".git":
            return normalize_name(common_dir.parent.name), "git_common_dir", evidence
        name = common_dir.name[:-4] if common_dir.name.casefold().endswith(".git") else common_dir.name
        return normalize_name(name), "git_common_dir", evidence
    if top_level:
        return normalize_name(Path(top_level).name), "git_top_level", evidence
    return normalize_name(cwd.name), "workspace_directory", evidence


def parse_json_output(output: str) -> Any:
    start = output.find("{")
    if start < 0:
        raise ValueError("OpenViking returned no JSON object")
    return json.loads(output[start:])


def list_resource_uris(cwd: Path) -> tuple[list[str], str | None]:
    if shutil.which("ov") is None:
        return [], "ov executable not found"
    code, stdout, stderr = run(["ov", "ls", f"{RESOURCE_ROOT}/", "-o", "json"], cwd)
    if code != 0:
        return [], stderr or stdout or f"ov ls exited with {code}"
    try:
        payload = parse_json_output(stdout)
        rows = payload.get("result", [])
        return [row["uri"].rstrip("/") for row in rows if row.get("isDir") and row.get("uri")], None
    except (ValueError, TypeError, KeyError, json.JSONDecodeError) as exc:
        return [], f"could not parse ov ls output: {exc}"


def worktree_names(cwd: Path) -> list[str]:
    listing = git(cwd, "worktree", "list", "--porcelain")
    if not listing:
        return []
    names: list[str] = []
    for line in listing.splitlines():
        if line.startswith("worktree "):
            names.append(Path(line.removeprefix("worktree ").strip()).name)
    return names


def match_existing(candidate: str, uris: list[str]) -> tuple[str, bool]:
    names = {uri.rsplit("/", 1)[-1]: uri for uri in uris}
    if candidate in names:
        return names[candidate], True
    matches = [uri for name, uri in names.items() if name.casefold() == candidate.casefold()]
    if len(matches) == 1:
        return matches[0], True
    if len(matches) > 1:
        raise ValueError(f"multiple OpenViking roots match {candidate!r} case-insensitively")
    return f"{RESOURCE_ROOT}/{candidate}", False


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cwd", type=Path, default=Path.cwd(), help="Workspace or repository path")
    parser.add_argument("--no-ov", action="store_true", help="Resolve locally without listing OpenViking roots")
    arguments = parser.parse_args()

    cwd = arguments.cwd.resolve()
    if not cwd.is_dir():
        parser.error(f"not a directory: {cwd}")

    candidate, source, evidence = project_candidate(cwd)
    uris, ov_error = ([], None) if arguments.no_ov else list_resource_uris(cwd)
    project_uri, exists = match_existing(candidate, uris)

    worktrees = worktree_names(cwd)
    worktree_folds = {name.casefold() for name in worktrees}
    legacy = sorted(
        uri
        for uri in uris
        if uri != project_uri and uri.rsplit("/", 1)[-1].casefold() in worktree_folds
    )

    branch = git(cwd, "branch", "--show-current")
    if not branch:
        branch = git(cwd, "rev-parse", "--short", "HEAD")

    result = {
        "project_name": project_uri.rsplit("/", 1)[-1],
        "project_uri": f"{project_uri}/",
        "resource_exists": exists,
        "resolution_source": source,
        "branch": branch,
        "legacy_worktree_resources": legacy,
        "openviking_error": ov_error,
        "evidence": evidence,
    }
    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
