---
name: analysis-cleanup
description: Use when the user wants an analysis script refactored (renamed variables, deduplicated logic, split into functions) WITHOUT changing any of the outputs the script produces. Snapshots all outputs before refactoring, applies changes, re-runs, and diffs — if any output changes, the refactor is rejected. Never silently changes a number.
allowed-tools: Read, Edit, Bash, Glob
invocation: confirm
---

Refactor an analysis script — rename variables, deduplicate logic, split into functions — **without changing any of the numbers it produces**. The discipline is enforced by snapshot-and-diff: outputs before == outputs after, or the refactor is rejected.

This is the inverse of [revision-plan.md](revision-plan.md): the revision plan intentionally changes results in response to a referee. Cleanup intentionally does not.

---

## When to Use

- The script works but is hard to read — duplicated blocks, opaque names, mile-long files
- Co-author or replicator will inherit the code soon
- Submission is imminent and the published numbers must not move

Do **not** use this skill if the user wants to fix a bug *and* clean up. Bug fixes change numbers by design — separate skill, separate commit.

---

## Non-negotiable rules

1. Snapshot every output the script produces *before* any edit: printed numbers, written files, figures.
2. After refactoring, re-run and diff every output against the snapshot. **Any** difference means the refactor is rejected.
3. Never round, reformat, or "tidy" a number on the way out. Bit-for-bit equivalence (or floating-point within `1e-10`) is the bar.
4. Refactors that intentionally change a result do not belong here.

---

## Workflow

```
Identify outputs → Snapshot baseline → Plan changes → Apply → Re-run → Diff → Verdict
```

### Step 1 — Identify the script and its outputs

One question: which file, and where do its outputs land (`figures/`, `tables/`, console)?

If outputs are scattered, grep the script for `write_csv`, `ggsave`, `cat`, `print`, `kable`, `stargazer`, `modelsummary`, `feols`, etc.

### Step 2 — Snapshot the baseline

```bash
mkdir -p snapshot/{tables_before,figures_before}

# Capture stdout
Rscript original_script.R 2>&1 | tee snapshot/console.txt

# Hash file outputs
md5sum figures/*.pdf tables/*.tex > snapshot/hashes.txt

# Save copies for human-inspectable diffs
cp tables/*.tex snapshot/tables_before/
cp figures/*.pdf snapshot/figures_before/
```

If the script depends on external state (database, slow simulation, API), snapshot from a deterministic-seed version.

### Step 3 — Classify proposed changes

| Class | Example | Allowed without confirmation? |
|---|---|---|
| **SAFE** | Pure rename, whitespace, comments, splitting a long function, dead-code removal | Yes |
| **RISKY** | Changing arguments to a function call, replacing a library, reordering operations | One-by-one user confirmation |
| **FORBIDDEN** | Anything that changes a number, even "obviously equivalent" math (e.g. `sum(x)/n` vs `mean(x)` if `n` was computed differently) | Never |

Apply only SAFE changes by default.

### Step 4 — Apply minimally

One change per edit. Smaller diffs are reviewable; bundled diffs are not.

### Step 5 — Re-run and diff

```bash
Rscript original_script.R 2>&1 | tee snapshot/console_after.txt
md5sum figures/*.pdf tables/*.tex > snapshot/hashes_after.txt

diff snapshot/hashes.txt snapshot/hashes_after.txt
diff -r snapshot/tables_before/ tables/
```

For floating-point output (e.g. coefficients in a `.tex` table), parse and compare numerically with tolerance `1e-10`. Beyond that — failure.

### Step 6 — Verdict

- **PASS** — every output identical (or within float tolerance). Print one-line summary plus the list of changes applied.
- **FAIL** — at least one output changed. Print the diff, **revert** the script to its pre-refactor state, and report which change introduced the divergence.

Never "PASS with caveats." Either the outputs match or they do not.

---

## Edge cases

- **PDF figures.** Image hashing is brittle because of PDF metadata (creation timestamps). Render to PNG at fixed DPI before hashing, or use perceptual hashing.
- **Multi-script pipelines.** Snapshot the whole Makefile target, not just one file.
- **Random seeds.** A refactor that legitimately reorders RNG calls will diverge even if mathematically equivalent. Either set finer-grained seeds or treat as RISKY.

---

## Trade-offs

| | This skill | Free-form refactor |
|---|---|---|
| Safety | Numbers can't move | Numbers can quietly move |
| Speed | Slower (re-run cost) | Faster |
| Best for | Pre-submission, replication packages | Early-stage exploration |

---

## Notes for extending

- **Figure diff.** Image hashing is brittle for PDFs because of metadata (creation timestamps, font subsetting). For figures, render to PNG at fixed DPI before hashing, or use perceptual hashing (e.g. `imagehash.phash`) and compare with a small Hamming-distance budget.
- **Multi-script pipelines.** Extend Step 2 to snapshot the full pipeline target (Makefile, Snakefile, `_quarto.yml`) rather than a single script. Hash every leaf output, not just the script's direct outputs.
- **Subagent pattern (`context: fork`).** Re-running the analysis can be slow and the diff machinery is verbose — exactly the case for forking a subagent. The main conversation only sees the final PASS/FAIL verdict; the snapshot files, hash diffs, and per-step logs stay in the subagent's context. This keeps the user's research dialogue uncluttered while preserving an audit trail in the subagent transcript.
