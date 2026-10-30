---
name: openviking
description: >-
  Project memory with canonical Git-repository routing across linked worktrees
  and renamed folders. Use before substantive project work to recover decisions,
  conventions, preferences, post-mortems, rationale, and indexed docs not evident
  from code. Record durable decisions after the work.
---

# OpenViking Project Memory

Use one canonical OpenViking resource per Git repository.

## 1. Resolve

Run the bundled resolver with the script path relative to this `SKILL.md`:

```text
py <skill-dir>/scripts/resolve_project.py --cwd <workspace-root>
```

Use its exact `project_uri` for all commands. It maps linked worktrees to the same
resource and preserves existing URI casing. If identity is ambiguous, set once:

```text
git config --local openviking.project <canonical-name>
```

Never derive the resource from the current folder name alone.

## 2. Retrieve

Query before substantive work, then read relevant results:

```text
ov find '<task and decision terms>' --uri '<project_uri>'
ov read '<result_uri>'
```

## 3. Record

Record only durable decisions, conventions, preferences, and post-mortems. Search
for an existing memory first and update it when appropriate.

Store new memories below `<project_uri>/memories/`:

```text
ov stat '<project_uri>/memories'
ov mkdir '<project_uri>/memories' --description 'Durable project memory'
ov write '<project_uri>/memories/YYYY-MM-DD-<slug>.md' --mode create --content '<markdown>'
```

Run `ov mkdir` only if the directory is missing. Include the date, status, scope,
context, decision, rationale, consequences, and relevant files or issue.

Use this metadata for project-wide memory:

```text
- Scope: project
```

Use both fields when information applies only to a branch:

```text
- Scope: branch-specific
- Branch: <exact-branch-name>
```

Always state branch scope inside the memory, even if its filename or directory names
the branch. Use `<project_uri>/workstreams/<name>/` only for substantial temporary
artifacts. Promote durable conclusions to project scope when the branch lands.

## 4. Guardrails

- Scope every read and write to `project_uri`.
- Never write to `viking://agent/`, `viking://user/`, or an unscoped root.
- Do not use `ov add-memory` or `ov session commit`; the installed CLI cannot target
  the project resource with them.
- Do not store secrets, routine progress, transcripts, or facts obvious from code.
- Ignore legacy per-worktree roots during normal work. Migrate them only as a separate,
  explicitly approved task with a backup; never silently move, merge, or delete them.
- If OpenViking is unavailable, say `Please run viking to enable my memory.` Then proceed.
