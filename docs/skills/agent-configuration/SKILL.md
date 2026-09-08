---
name: agent-configuration
title: Agent Configuration
permalink: /skills/agent-configuration/
description: Use when configuring an agent for a research project — writing AGENTS.md with research-specific Data Provenance and Citation Policy sections, organizing project documentation into stable and evolving layers, keeping agent and human front doors in sync, defining reproducibility and analysis conventions, and decomposing work across subagents. Inspects the project directory to populate instructions from real evidence rather than boilerplate.
allowed-tools: Read, Edit, Write, Bash, Glob, Grep
---

## AGENTS.md

`AGENTS.md` is the project instruction file for Codex. Keep durable, project-specific guidance here so future sessions can recover the conventions they need.

**What belongs in AGENTS.md:**

- Project layout (which directories hold what)
- Non-obvious conventions (naming and output locations)
- Verification commands (how to test that the code/analysis is correct)
- Subagent inventory, if used: names, purposes, and relevant project context to include in task briefs.

**What does not belong:**

- Things derivable from the code (don't describe what the code already says)
- Temporary task state (use task notes or a separate scratchpad)
- Generic best practices (the model already knows these)
- Blanket tool restrictions or machine-specific compiler/path overrides; keep setup details in environment or build configuration and link to them when useful
- Blanket bans on deleting stale process files; allow routine cleanup once files are confirmed obsolete and no active process depends on them

**Compaction survival test:** Read each line in AGENTS.md and ask "if this disappeared after a context reset, would the agent make a wrong decision?" If no, cut it.

### Where documentation lives — the layers, and AGENTS.md's place in them

A mature research project organizes into five execution layers (`code/`, `data/`, `docs/`, `notes/`, `output/`), and AGENTS.md is the layer that governs the other four rather than storing content itself. `code/` is for preprocessing and crawling; result-generating scripts used to reproduce outputs belong under `output/code/`; smaller processed data and reproducibility caches belong under `output/data/`; `data/` is mainly for raw data and processed data that remains large. The full model — the five-layer and documentation-roles tables, the analysis naming convention, the front-door-vs-content distinction, the two logging configurations (with / without a `notes/` wiki), and the wiki maintenance contract that must live in AGENTS.md — is in `references/docs-layers.md`. Read it when scaffolding a full research-project structure.

The one load-bearing rule to hold here: **front doors (AGENTS.md, README) are thin routers, not content bodies.** They point into `docs/` and `notes/`; when tempted to explain a method inside AGENTS.md, write it in `docs/` and link.

### Analysis naming and output conventions

When several analyses address the same substantive topic, use the listing number as the analysis name (for example, `01_localization`, `02_localization`) rather than inventing unrelated names. Keep the number and name consistent across the analysis script, output files, notes, and documentation so a reader can identify the complete unit from any layer.

Use the directory split below when scaffolding or auditing a research project:

- `code/`: preprocessing, crawling, ingestion, and other scripts that prepare inputs;
- `output/code/`: result-generating scripts that produce tables, figures, reports, or other outputs and are required for reproducibility;
- `data/`: mainly raw data, plus processed data that remains large or is treated as a primary project input;
- `output/data/`: smaller processed data, intermediate artifacts, or caches that are shipped or retained to reproduce outputs;
- `output/`: derived results, with scripts in `output/code/` and reproducibility data in `output/data/`.

Do not duplicate a preprocessing script in `output/code/`. A result-generating script should consume a named input, record its provenance, and write a predictable output keyed to the same numbered analysis name.
### Keeping AGENTS.md and README in sync (active development)

AGENTS.md and an active-development README are two living docs with two different jobs. Keep them separate — do not let either drift into the other's role.

- **AGENTS.md — brief, current-state only, no historical logs.** It records what is true *now*: layout, constraints, conventions, the subagent inventory. Keep it concise because it becomes part of the agent's working context. Never let it accumulate a changelog or a record of what *used to be* true — when something changes, rewrite the line to the new state and move on.
- **README.md (active development) — the detailed living doc + a dated update log.** This is where depth lives: extended rationale, design notes, and a changelog with dated entries describing what changed and why. It is *not* loaded into context automatically, so length is cheap. (This is distinct from the *replication-package* README — the public handoff — covered later in this skill.) **Caveat — this is the lightweight configuration** (no `notes/` wiki). Once a `notes/` wiki exists, the changelog moves to `notes/log.md` and the rationale to `notes/methodology/decisions.md`; README then shrinks to pure human orientation and the sync rule below runs against `notes/log.md` instead. See "Where documentation lives" above.

**Sync rule.** When a change significantly alters project structure, conventions, or status, update **both**: refresh the affected current-state line(s) in AGENTS.md, and append a dated entry to the README changelog. Minor or in-progress edits (debugging, exploratory commits, half-finished refactors) do **not** trigger an update — only changes a future session would otherwise misread.

### Research-project AGENTS.md (mandatory sections)

Generic AGENTS.md guidance is not enough for a research project. Reproducibility and citation integrity are research-specific concerns that the model will not enforce on its own — they have to be written down. **Two sections are non-negotiable** for any dissertation, paper replication, or working-paper repo:

1. **Data Provenance.** Sources, access (license, embargoes, how to re-obtain raw data), versioning (how data versions are tracked). Research projects without data lineage become unreproducible the moment the original author leaves. If the directory has no data folder yet, leave the section as a checklist for the user to fill in — but include the heading.
2. **Citation Policy.** Every cited paper must have a verified DOI in `references.bib`. Reference the [`literature-review`](../literature-review.md) skill as the verification path — Path A (OpenAlex search → Crossref DOI verification) for indexed work, Path B (post-hoc DOI / title / author / year / venue checklist) for grey literature.

### Generating a research AGENTS.md (workflow)

```
Inspect → ask ≤2 questions → emit → diff against existing
```

**Step 1 — Inspect the project** (do not ask the user what `ls` can answer).

```bash
# Languages present
fd -e py -e R -e do -e ipynb -e qmd -e Rmd | head -40

# Data folder conventions
ls -d data raw_data data/raw data/processed 2>/dev/null

# Build / pipeline tooling
ls Makefile Snakefile _quarto.yml renv.lock requirements.txt 2>/dev/null

# Existing AGENTS.md
test -f AGENTS.md && head -200 AGENTS.md
```

Capture: dominant language, data folder location (if any), pipeline entrypoint, presence of pre-commit / CI / Quarto, any existing AGENTS.md.

**Step 2 — Ask up to 2 questions.** Only what cannot be inferred:

1. What is the research question this project addresses? (one sentence)
2. What is the target output? (paper, dissertation chapter, replication package, working paper)

Skip if already answered. **Never ask about anything readable from the directory.**

**Step 3 — Emit** (skip irrelevant sections for empty projects, but keep the headings as scaffolding):

```markdown
# AGENTS.md — <project-name>

## Project Overview
<one paragraph from Step 2>

## Environment
<link to the project's environment and build configuration; describe languages in use without imposing tool or machine-path restrictions>

## Repository Layout
<top-level dirs, one-line description each>

## Data Provenance
- **Sources:** <data sources, or TODO list>
- **Access:** <how to obtain raw data; license; embargoes>
- **Versioning:** <how data versions are tracked>

## Coding Conventions
<concrete rules derived from a quick read of existing files — never invent
a convention the project does not actually use>

## Reproducibility
- Random seeds: <set in code; if absent, flag>
- Environment: <requirements.txt / renv.lock / etc.>
- Pipeline entrypoint: <Makefile target / Quarto file / driver script>

## Citation Policy
- Every cited paper must have a verified DOI in `references.bib`.
- Use the [`literature-review`](../literature-review.md) skill (Path B verification checklist) before committing the bibliography.

## Conventions for Codex

**Operational rules** (concrete, apply every time):

- When writing new analysis: use the numbered substantive analysis name consistently; put preprocessing/crawling in `code/`, result-generating reproducibility scripts in `output/code/`, and their smaller processed inputs or caches in `output/data/`; produce both the code and the output it generates.
- For established estimation or prediction methods (for example, DID, CS-DID, FECT, and DML): default to an existing, maintained R package with documented methodology and a pinned version rather than hand-coding the estimator in Python. Implement a custom estimator only when the user explicitly requests it or no suitable package supports the required specification; document the reason and verify it by matching an established implementation on benchmark data or recovering known simulation truth.
- When proposing a method change: state which result(s) it would change before editing.
- When uncertain about a number or citation: flag with `[TODO]` rather than guess.
- When a task splits into independent subtasks: decompose it and dispatch the subtasks to subagents in parallel (one message, multiple tool calls). Do not parallelize work that shares mutable state or has a true sequential dependency.
- When a change significantly alters structure, conventions, or status: refresh the affected current-state line(s) in AGENTS.md (no changelog) and append a dated entry to the running log (`notes/log.md` if a wiki exists, else the README update log). Skip for minor or in-progress edits.
- After each meaningful operation: append one entry to `notes/log.md` as `## [YYYY-MM-DD] operation | description` (typed operation: `ingest` / `lint` / `strategy` / …); link to the phase plan and `[[decisions#...]]` rather than restating them. (Omit this rule if the project has no `notes/` wiki.)
- Periodically: lint the wiki — sweep for orphan pages, stale claims, and missing cross-references; fix or flag, and record the sweep as a `lint` log entry. (Omit if no wiki.)
- Single source of truth per fact: a number lives on one page and is linked, never copied. Never restate a result or a decision in a second location — link to it.
- At end of a completed task with a non-clean working tree: let the [`version-control`](../version-control.md) skill commit and push. Tag AI-assisted commits with `[AI]` if this repo documents that policy.
- Clean up obsolete temporary files, stale process files, and disposable build byproducts when useful to the task. Confirm they are no longer in use and preserve source files, research evidence, and artifacts needed for reproducibility.

**General principles** (*optional* — condensed from [Karpathy's LLM-coding CLAUDE.md](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md); use when a novel situation isn't covered by the rules above). The model already knows these, so they earn their every-turn context cost only when a team wants them stated as enforced house rules. Keep the four one-liners or drop the block; do not paste the full source in — it bloats a file that loads on every turn. They bias toward caution over speed; for trivial tasks, use judgment.

- **Think before coding.** State assumptions explicitly. If a request has multiple interpretations, present them — do not pick silently. If something is unclear, stop and name what's confusing before implementing.
- **Simplicity first.** Minimum code that answers the question. No speculative features, no abstractions for single-use scripts, no error handling for impossible inputs. If 200 lines could be 50, rewrite it.
- **Surgical changes.** Touch only what the task requires. Match the existing style. Do not refactor adjacent blocks or "improve" unrelated code. Remove confirmed obsolete process files and task-related dead code when useful; preserve unrelated work. The test: every changed line traces directly to the user's request.
- **Goal-driven execution.** Convert tasks into verifiable goals before running them, and state a brief plan as `[step] → verify: [check]` for multi-step work. Strong success criteria let the agent loop until verified without re-asking.
```

**Step 4: Update any existing AGENTS.md and review the diff.** Apply the requested changes directly, preserve unrelated project guidance, and summarize the meaningful changes. Ask only when an unresolved conflict requires the user's decision.

### Notes for extending

- **General principles — full source.** The four one-liners in the template are a deliberate compression. The full role-by-role version (Think Before Coding / Simplicity First / Surgical Changes / Goal-Driven Execution, with the rationale and the "working if…" test) lives in `references/general-principles.md`. Read it when deciding *whether* to include the block in a given project, or when expanding a principle into a concrete house rule. It stays out of both this skill's body and the generated AGENTS.md so neither carries generic best-practice text that loads on every turn.
- **Per-language profiles.** Factor language-specific convention blocks into `profiles/<lang>.md` files (R, Python, Stata, Julia). Loaded as Level-3 resources only when the language is present — keeps the main file short.
- **Multi-machine projects.** Link to environment or setup documentation for each machine; keep local paths and overrides in configuration.

### Generating a replication-package README (handoff to public)

The AGENTS.md above is for **active development**. A replication-package **README** is a different deliverable — the public handoff, where a reviewer clones the repo and runs the pipeline end-to-end. That workflow (inspect package -> run order -> outputs -> emit README + TODO, under the rules that every command be runnable verbatim, every version pinned, and every output keyed to a paper figure/table) is its own skill: use the `replication-readme` skill. Don't duplicate it here.

## Task Decomposition and Subagent Delegation

**Decompose, then parallelize.** When a task splits into independent subtasks, break it apart and dispatch the pieces to subagents in a **single message with multiple tool calls** so they run concurrently instead of one-after-another. The library already uses this pattern: the [`appendix`](../appendix/SKILL.md) skill fans out a parallel grounding pass over independent claims, and [`skill-creator`](../skill-creator.md) launches with-skill and without-skill eval runs in the same turn so they finish together. Merge the results once they return.

Do **not** parallelize subtasks that share mutable state or have a true sequential dependency (subtask B needs subtask A's output) — run those in order.

Delegate to a subagent when a subtask is:

- **Isolated** — it doesn't need the main session's full context
- **Context-heavy** — running it inline would fill the window before the main task finishes
- **Risky** — you want failures contained and recoverable

**What makes a good subagent prompt:**

Include the context a subagent needs in its brief rather than assuming it has the relevant session history:

```
Context: [1–2 sentences on the project and why this task matters]
Task: [Exactly what to do, with file paths]
Output: [Where to write results and in what format]
Constraints: [Any rules from AGENTS.md that apply]
```

**When not to delegate:** If the subtask needs information that only exists in the current conversation (live variable values, intermediate results held in memory), keep it in the main session.

## Automated Version Control

The [`version-control`](../version-control.md) skill auto-fires when end-of-task is signaled and the working tree is non-clean. It infers the repo's commit-message style from the last 10 commits, runs project-specific build hooks (e.g., the CV rebuild when `code/cv.tex` changes), commits, and pushes. You do not re-state which files belong, what the message should say, or whether the build artifact is current.

**Why a skill, not a `Stop` hook.** A hook would fire after every assistant turn, but most turns are not commit-worthy — debugging steps, exploratory edits, half-finished refactors. A skill defers to model judgment about *whether* this is a good checkpoint, while remaining trivial to invoke explicitly when you want it ("commit this", "save", "push").

**Per-project tuning.** Record any of the following in the project's AGENTS.md so the skill picks them up automatically:

- `[AI]` disclosure tag policy (research repos that track AI-assisted commits)
- Conventional-commit prefixes if the repo uses them
- Pre-commit build steps tied to specific file changes (LaTeX → PDF, Quarto render, figure regeneration)
- Sensitive paths to never stage (data files, credentials, large binaries)

The skill reads AGENTS.md before committing and respects whatever is documented there. Conventions that are not written down will not be applied.

**What the skill will not do:**

- Open pull requests (`gh pr create` is a separate, explicit step)
- Bypass pre-commit hooks (`--no-verify`)
- Amend a previous commit after a hook failure (creates a new commit instead — `--amend` would silently modify the wrong commit)
- Force-push to `main`
- Stage files indiscriminately (`git add -A` / `git add .` are forbidden because they sweep in `.env`, credentials, and untracked binaries)

**Invocation.** Auto-triggered, but you can also be explicit: "commit", "push", "save the current state", "snapshot this", "ship it". If the working tree is clean or the changes look mid-task, the skill asks before firing rather than guessing.
