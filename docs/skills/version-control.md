---
name: version-control
description: >-
  Use for Git commit, save, snapshot, backup, and push requests; after each substantial, coherent revision when the user or project guidance establishes automatic checkpoints; and at task completion when a standing commit/push policy applies. Also use for an authorized push when the working tree is clean but local commits remain unpushed. Inspect and stage only task changes, run applicable checks, match the repository's commit style, create local revision commits, and push at completion when authorized.
allowed-tools: Bash, Read
---

# Automated Version Control

Committing well is a separate cognitive task from the work itself. By the time you finish editing a paper section or a script, you no longer want to think about *which* files belong in *which* commit, what the message should say, or whether the CV PDF still matches `cv.tex`. This skill offloads that.

Create local commits at revision checkpoints and push separately when authorized. Follow the project's branch and review conventions; do not assume every repository works directly on `main`. Opening a PR is a separate workflow.

Scope: preserve revision history through Git commits. Result-family organization and provenance conventions belong to [`agent-configuration`](agent-configuration/SKILL.md). Keep alternative designs in the same result-family folder, distinguish metrics and variants in filenames, and keep run dates and manifests in provenance. Never create dated, version-suffixed, or duplicate result folders as a substitute for Git history. Git preserves only committed, tracked content; provenance identifies retained versions of artifacts stored elsewhere.

---

## Movement 1 — When to fire

Choose the action from the user's request and standing project guidance:

- **Revision checkpoint:** after a substantial, coherent revision, commit locally before starting the next substantial revision if automatic checkpoints are authorized. Examples include a completed manuscript-section rewrite, a verified analysis specification change, or a working implementation milestone. Do not wait for the entire task to finish or create a commit per small edit.
- **Task completion:** commit any remaining coherent task changes. Push when the user or project guidance authorizes pushing at completion. Check for unpushed commits even if the working tree is clean.
- **Explicit request:** perform the requested action. A request to commit, save, or snapshot does not by itself request a push. A push request with no new changes can still require publishing existing commits.

Authorization persists across turns; it is not limited to the last two messages. Honor explicit instructions to defer commits or pushes, and do not repeatedly ask for approval already given. If the action or destination remains genuinely ambiguous, inspect and prepare the concrete scope first, then ask only for the missing decision.

Automatic checkpoints require a coherent revision with applicable checks passing. Fix task-related failures before committing; report blockers that cannot be resolved. Existing TODOs or unrelated work in progress do not block a valid checkpoint. An explicit request to snapshot unfinished work can be honored with a descriptive message and an honest account of failing checks, but never bypass hooks.

---

## Movement 2 — Snapshot the state

Locate the containing repository with `git rev-parse --show-toplevel` and work from that root. A project subfolder uses its containing repository; do not create nested repositories to track individual result folders. If no repository exists, follow any existing initialization authorization; otherwise report that history cannot yet be recorded and ask whether to initialize one.

Read AGENTS.md or the project's equivalent for staging exclusions, checks, branch policy, and disclosure rules. Then inspect independent state reads in parallel:

```bash
git status --short
git diff --stat
git diff --cached --stat
git log -10 --oneline
git branch --show-current
```

From these, decide:

- **What changed** — inspect full staged and unstaged diffs for candidate paths and read candidate untracked files; statistics alone are insufficient.
- **What belongs in this commit** — use the task scope and initial working-tree state. Recent commit authors do not establish ownership of uncommitted edits. Preserve unrelated edits, deletions, and pre-existing staged content.
- **Message style** — read the last 10 subject lines and pick the dominant pattern. For this user's personal projects: lowercase, descriptive, present-tense, occasional `;` to separate two changes ("rename working paper to X; fix skill links"). For research repos with `[AI]` disclosure policy in CLAUDE.md: prepend `[AI]` for AI-assisted commits.

Never assume conventional-commit format unless the recent log already uses it.

An unborn branch has no log yet; use project conventions or the defaults below. A detached HEAD or unresolved merge/rebase needs deliberate handling before an automatic checkpoint; do not switch branches or finish an unrelated operation implicitly.

---

## Movement 3 — Project-specific build hooks

Read current project guidance and build configuration for required checks and generated outputs. Run the checks applicable to the proposed commit; reuse successful checks only while their relevant inputs remain unchanged. Do not copy machine-specific compiler paths or obsolete build recipes into this reusable skill.

For this website, changes to `code/cv.tex` require rebuilding the single CV with abstracts and updating `docs/assets/cv.pdf` using AGENTS.md's current procedure. Inspect output-only changes for legitimate regeneration or stale artifacts before deciding what to stage; they do not automatically require confirmation.

If a required build fails, diagnose and fix task-related problems, then rerun it. Do not commit stale or partial generated outputs. If blocked, report the failing command and relevant error. Builds and commits do not authorize cleanup of source files or retained artifacts.

---

## Movement 4 — Group and stage

Stage by **topic**, not by file count. Split unrelated topics only when both belong to the authorized task; leave other work alone.

Never use `git add -A` or `git add .`. Sensitive files (`.env`, credentials, large binaries) sneak in that way. Stage by explicit path:

```bash
git add -- code/cv.tex docs/assets/cv.pdf
```

If `git status` shows files you do not recognize (unexpected untracked files, configuration overrides, build artifacts), **investigate before staging**. Do not silently include them.

Explicit paths still stage every change within each named file. Use selective hunks for mixed files when their ownership is clear; otherwise resolve the overlap before committing. Do not unstage or include unrelated pre-existing staged changes. Use an isolated index or another verified Git method when needed to commit only the task scope while preserving the existing index.

Before committing, inspect the exact proposed staged diff and run `git diff --cached --check` against the index that will be committed. Verify it contains only intended changes and required outputs. If there are no task changes, skip the commit without creating an empty checkpoint.

---

## Movement 5 — Draft the message

The subject line carries the meaning. Body text is rare — only when the *why* is non-obvious from the diff.

**Subject — match the repo's pattern, with these defaults for this user's repos:**

- lowercase, descriptive, present-tense or imperative
- ≤ 72 characters
- one or two coordinated changes joined with `;` ("rename X; fix Y")
- no period at the end
- no decorative prefixes ("Misc:", "Update:") unless the repo already uses them

**Body — only include when:**

- the change is non-trivial and the diff alone won't tell a future reader why
- there is a referenced issue/PR/incident the future reader will need
- the change reverts or supersedes a prior commit and naming it helps

**Trailers:**

- `Co-Authored-By` — follow documented repository policy and use only accurate, established attribution. Do not copy a model identity from an old commit or invent one. This personal website does **not** use this trailer.
- `[AI]` subject prefix — only if project guidance mandates it. This personal website does **not** mandate it.

**Forbidden subject patterns** — these waste the line:

- `update`, `update file`, `various changes`, `wip`, `fix bug`
- `iterative updates` (acceptable in private exploratory work, but write what was iterated when possible)
- generic `chore:` / `docs:` without a noun phrase after them

---

## Movement 6 — Commit, verify, and optionally push

```bash
git commit -m "<subject>"
```

If a pre-commit hook fails:

1. Read the hook's output.
2. Fix the underlying issue (lint error, type error, formatting).
3. Inspect hook modifications, re-stage only task changes, rerun affected checks, and retry with a normal `git commit`. Never use `--no-verify` or `--amend` to get past a failed hook; a failed pre-commit hook leaves the previous commit at HEAD.

Verify the resulting commit's hash and contents and inspect remaining working-tree and index changes. If a commit command fails unexpectedly, check whether HEAD advanced before retrying. Checkpoints should add history, not rewrite earlier revisions.

At a revision checkpoint, stop here and continue the task. At an authorized push, inspect the remote, branch, upstream, and outgoing commits first. Push to the established destination; if it is missing or ambiguous, keep the local commits and request only the missing destination. Do not invent a remote or push unrelated outgoing commits without authorization. Run `git push` only after this scope is clear, then verify the remote branch contains the intended commits. Report a local-only result if no push is required or possible.

If the push is rejected (non-fast-forward):

- Fetch the established remote and inspect divergence from the upstream (quote `'@{u}'` in PowerShell).
- Follow the project's integration policy. Rebase only unpublished task commits when the index and working tree permit it; do not automatically stash unrelated work, rewrite shared commits, or rebase a dirty tree. Resolve conflicts only when the intended result is clear and rerun affected checks.
- If integration cannot proceed safely, retain local commits and report the blocker. Never force-push as a routine retry; any history rewrite requires separate explicit authorization.

---

## Movement 7 — Output

For a standalone commit/push request, report briefly:

```
<new HEAD short SHA> — "<subject>"
  files: <comma-separated list, truncated to ~6 items + "and N more">
  push:  <ok | deferred until task completion | not requested | blocked/failed: reason>
```

For a checkpoint within a larger task, record the hash and continue working; do not end the task just because a commit succeeded. At task completion include commit/push status with the substantive result and validation. If no commit was needed, say so; do not imply an existing HEAD was newly created. Mention material checks or remaining blockers concisely.

---

## Cross-references

- [`agent-configuration`](agent-configuration/SKILL.md) §Automated Version Control — wiring, per-project tuning, and the rationale for skill-vs-hook.
- [`ai-disclosure-block`](ai-disclosure-block.md) — when the target project requires `[AI]` subject tags or end-of-pipeline AI-use disclosure.
