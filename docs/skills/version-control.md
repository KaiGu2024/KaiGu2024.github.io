---
name: version-control
description: Use when the user signals end-of-task and a non-clean working tree exists — explicit verbs ("commit", "push", "save", "snapshot", "back this up", "ship it") or completion phrases ("done", "looks good") after a round of edits with files modified. Inspects what changed, infers the repo's commit-message style from recent history (informal lowercase by default; conventional commits if the repo already uses them), runs project-specific build hooks (e.g., the CV rebuild when `code/cv.tex` is staged), commits, and pushes to the current branch. Honors the git-safety rules from the system prompt: never `git add -A`, never `--no-verify`, never `--amend` after a hook failure, never force-push to `main`.
allowed-tools: Bash, Read
invocation: confirm
---

# Automated Version Control

Committing well is a separate cognitive task from the work itself. By the time you finish editing a paper section or a script, you no longer want to think about *which* files belong in *which* commit, what the message should say, or whether the CV PDF still matches `cv.tex`. This skill offloads that.

It commits and pushes. It does **not** open PRs — this repo's workflow is solo on `main`. For collaborative repos with a PR convention, invoke `gh pr create` separately after the skill finishes.

---

## Movement 1 — When to fire

Fire when **all** of the following hold:

- the working tree is non-clean (`git status --short` returns ≥1 line)
- the user has signaled task completion in their last 1–2 messages — explicit ("commit", "push", "save", "snapshot", "ship it") or implicit ("done", "looks good", "that's all")
- the changes form a coherent unit (one topic, or two related topics that can be split into two commits)

Do **not** fire when:

- the user is mid-debugging (last assistant turn was diagnosing an error)
- the changes contain obvious work-in-progress (`TODO` blocks, commented-out experiments, broken tests)
- a build step is failing and unresolved
- the user said "not yet" or "later" about committing in this session

If a fire condition is ambiguous, ask one question: *"Commit current changes? `<one-line summary of what's staged + unstaged>`"*. Don't ask repeatedly across the same session — once is enough.

---

## Movement 2 — Snapshot the state

Run in parallel:

```bash
git status --short
git diff --stat
git log -10 --oneline
```

From these, decide:

- **What changed** — files, lines, scope (`status` + `diff --stat`)
- **Whose work** — yours alone, or coauthors' commits in the recent log
- **Message style** — read the last 10 subject lines and pick the dominant pattern. For this user's personal projects: lowercase, descriptive, present-tense, occasional `;` to separate two changes ("rename working paper to X; fix skill links"). For research repos with `[AI]` disclosure policy in CLAUDE.md: prepend `[AI]` for AI-assisted commits.

Never assume conventional-commit format unless the recent log already uses it.

---

## Movement 3 — Project-specific build hooks

### CV rebuild (this repo)

If `code/cv.tex` is in the diff, the website's `docs/assets/cv.pdf` must be regenerated *before* the commit, or the source and the published PDF will drift.

```bash
TINYTEX="/c/Users/kaizhu/AppData/Roaming/TinyTeX/bin/windows"
cd code
PATH="$TINYTEX:/c/Windows/System32" "$TINYTEX/pdflatex.exe" \
  -interaction=nonstopmode \
  -output-directory="../output" \
  "\def\hideabstracts{}\input{cv.tex}"
cd ..
cp output/cv.pdf docs/assets/cv.pdf
```

(Short version — no abstracts — because that is what the website ships.)

If pdflatex returns non-zero, **stop**. Print the last ~30 lines of the log and ask the user to resolve. Do not commit a stale or partial PDF.

If `code/cv.tex` is **not** staged but `docs/assets/cv.pdf` is — that is suspicious, because the PDF is built from source. Warn before committing: *"Committing cv.pdf without cv.tex change — did you mean to?"*

### Other repos

Read the project's CLAUDE.md for build commands. If it documents a pre-commit build (e.g., Quarto render, LaTeX compile, figure regeneration tied to a script change), run it in the same way: detect the trigger file, run the build, fail closed on errors.

---

## Movement 4 — Group and stage

Stage by **topic**, not by file count. If the diff cuts across two unrelated topics (e.g., a CV update *and* a skill edit), make two commits — one per topic.

Never use `git add -A` or `git add .`. Sensitive files (`.env`, credentials, large binaries) sneak in that way. Stage by explicit path:

```bash
git add code/cv.tex docs/assets/cv.pdf
```

If `git status` shows files you do not recognize (unexpected untracked files, configuration overrides, build artifacts), **investigate before staging**. Do not silently include them.

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

- `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` — only if the repo's recent commits already use this trailer or the project's CLAUDE.md asks for it. This personal website does **not** use it; do not add.
- `[AI]` subject prefix — only if the repo's CLAUDE.md has an AI disclosure section that mandates it (research repos, per the `agent-configuration` skill). This personal website does **not** mandate it.

**Forbidden subject patterns** — these waste the line:

- `update`, `update file`, `various changes`, `wip`, `fix bug`
- `iterative updates` (acceptable in private exploratory work, but write what was iterated when possible)
- generic `chore:` / `docs:` without a noun phrase after them

---

## Movement 6 — Commit and push

```bash
git commit -m "<subject>"
git push
```

If a pre-commit hook fails:

1. Read the hook's output.
2. Fix the underlying issue (lint error, type error, formatting).
3. Re-stage and **make a new commit** — do **not** `--amend`. After a hook failure the original commit did not happen, so `--amend` would silently modify the *previous* commit (potentially someone else's, or your own earlier work) and destroy history.

If the push is rejected (non-fast-forward):

- Inspect with `git fetch` + `git log HEAD..@{u}`.
- If upstream has commits you don't have, `git pull --rebase` and resolve any conflicts manually.
- **Never** `git push --force` to `main`. Force-push is acceptable only on personal feature branches and only after confirming with the user.

---

## Movement 7 — Output

Print three lines and stop:

```
✓ <new HEAD short SHA> — "<subject>"
  files: <comma-separated list, truncated to ~6 items + "and N more">
  push:  <ok | failed: reason>
```

(If the user dislikes the checkmark glyph, drop it — match their preference, no emoji elsewhere.)

Do not produce a multi-paragraph summary of what was committed. The diff is on disk; the user can read it.

---

## Cross-references

- [`agent-configuration`](agent-configuration.md) §Automated Version Control — wiring, per-project tuning, and the rationale for skill-vs-hook.
- [`ai-disclosure-block`](ai-disclosure-block.md) — when the target project requires `[AI]` subject tags or end-of-pipeline AI-use disclosure.
