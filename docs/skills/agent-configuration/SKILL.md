---
name: agent-configuration
title: Agent Configuration
permalink: /skills/agent-configuration/
description: Create and maintain project agent instructions, documentation conventions, and delegation rules. Use when configuring a research project or when completed work establishes durable decisions or recurring lessons, or makes existing guidance obsolete. Derive rules from evidence in the repository.
allowed-tools: Read, Edit, Write, Bash, Glob, Grep
---

## AGENTS.md

`AGENTS.md` is the project instruction file for Codex. Keep durable, project-specific guidance here so future sessions can recover the conventions they need.

**What belongs in AGENTS.md:**

- Project layout (which directories hold what)
- Non-obvious conventions (naming and output locations)
- Verification commands (how to test that the code/analysis is correct)
- Protected source paths, approved build roots, and limits on cleanup
- Subagent inventory, if used: names, purposes, and relevant project context to include in task briefs.

**What does not belong:**

- Things derivable from the code (don't describe what the code already says)
- Temporary task state (use task notes or a separate scratchpad)
- Generic best practices (the model already knows these)
- Tool preferences without a project-specific reason, or machine-specific compiler/path overrides; keep setup details in environment or build configuration and link to them when useful

Source-protection and deletion limits belong in AGENTS.md even when they prohibit a whole class of cleanup commands. Do not weaken them into generic advice to clean up stale files. Written instructions guide behavior; they do not establish filesystem permissions.

**Compaction survival test:** Read each line in AGENTS.md and ask "if this disappeared after a context reset, would the agent make a wrong decision?" If no, cut it.

### Project layout and documentation

Keep AGENTS.md as concise, current operational guidance and README as human orientation. Link to detailed project knowledge in `docs/` and `notes/`. Without a wiki, README also holds rationale and a dated update log; with a wiki, use `notes/methodology/decisions.md` and `notes/log.md` instead.

Read [documentation layers](references/docs-layers.md) when scaffolding or auditing project structure, analysis naming, or a notes wiki. The reference defines the directory roles and supporting documentation; the template below carries the operational rules into the project.

### Maintaining guidance as work advances

Use this skill during ordinary project work when an explicit user decision, a verified project change, or a recurring lesson establishes durable guidance or supersedes an existing instruction. For maintenance, inspect the affected instructions and their supporting evidence, then edit them directly; the full generation workflow below is for creating or substantially restructuring a configuration.

Apply the template's maintenance rule to AGENTS.md or the project's existing equivalent, such as CLAUDE.md, so later sessions can follow it without first selecting this skill. Preserve unrelated guidance and resolve conflicts with explicit user instructions before replacing them. Keep project-specific lessons in project guidance; update the reusable skill when the task includes improving guidance that applies across projects.

### Research-project AGENTS.md (mandatory sections)

Generic AGENTS.md guidance is not enough for a research project. Reproducibility, citation integrity, and preservation of authoritative files need explicit project guidance. **Three sections are non-negotiable** for any dissertation, paper replication, or working-paper repo:

1. **Data Provenance.** Sources, access (license, embargoes, how to re-obtain raw data), versioning (how data versions are tracked). Research projects without data lineage become unreproducible the moment the original author leaves. If the directory has no data folder yet, leave the section as a checklist for the user to fill in — but include the heading.
2. **Citation Policy.** Every cited paper must have a verified DOI in `references.bib`. Reference the [`literature-review`](../literature-review.md) skill as the verification path — Path A (OpenAlex search → Crossref DOI verification) for indexed work, Path B (post-hoc DOI / title / author / year / venue checklist) for grey literature.
3. **Protected files and cleanup.** Identify authoritative sources, retained outputs, approved build roots, the cleanup procedure, and recovery arrangements. Default unknown files to preserved. Read `references/source-protection.md` ([view reference](https://github.com/KaiGu2024/KaiGu2024.github.io/blob/main/docs/skills/agent-configuration/references/source-protection.md)) when creating or revising this section. Keep the essential limits directly in AGENTS.md; put the tailored procedure in project documentation and link to it. Record whether sandbox/OS protection is configured and tested; never imply that generating this section locks directories.

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

Also inspect source/manuscript locations, retained outputs, build and cleanup commands, and any existing protection or recovery configuration. Identify whether build files share a directory with sources. Record unknown build roots, manifests, permissions, or backups as unverified; do not invent them or run cleanup during inspection.

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

## Protected files and cleanup
- Protected: <observed manuscript, bibliography, image, data, script, and retained-output paths>; unknown files are preserved. Protect `.tex`, `.bib`, `.bbl`, `.sty`, `.cls`, and paper images/data/PDFs by default, including those under `output/`.
- Build roots and cleanup procedure: <verified roots and project-document link; if absent, no cleanup is configured>. Filesystem protection and recovery: <configuration/backup location and verification status, or unverified>.
- Cleanup starts with a dry-run listing the absolute build root, each candidate's full path, deletion reason, and regeneration evidence. Execute only after explicit approval of that exact list; reuse approval only while its scope and file/path state remain unchanged.
- Delete only ordinary auxiliary files confirmed generated by that build inside its approved root and unused by active processes. Never delete directories, recursively delete trees, sweep the project by extension, or use repository cleaning/bulk rollback as build cleanup.
- Check the root, every path ancestor, and every candidate before execution. Stop on junctions, symlinks, other reparse points, path escape, changed state, unknown file types, or inspection errors. Never follow links for cleanup.
- A deletion failure ends cleanup: preserve and report the original error. Do not switch shells/implementations, elevate, change permissions, or expand writable roots to retry. If safety cannot be established, keep the temporary files.

## Conventions for Codex

**Operational rules** (concrete, apply every time):

- **Advance the core task.** Do not spend effort defending against hypothetical objections, hypothetical use cases, or irrelevant failure modes unless doing so materially improves the current task or advances the analysis. In writing and coding, tie each caveat, check, or abstraction to a concrete consequence for interpretation, correctness, or use. Keep material uncertainty and safeguards for credible risks.
- When writing new analysis: use the numbered substantive analysis name consistently; put preprocessing/crawling in `code/`, result-generating reproducibility scripts in `output/code/`, and their smaller processed inputs or caches in `output/data/`; produce both the code and the output it generates.
- For established estimation or prediction methods (for example, DID, CS-DID, FECT, and DML): default to an existing, maintained R package with documented methodology and a pinned version rather than hand-coding the estimator in Python. Implement a custom estimator only when the user explicitly requests it or no suitable package supports the required specification; document the reason and verify it by matching an established implementation on benchmark data or recovering known simulation truth.
- When proposing a method change: state which result(s) it would change before editing.
- When uncertain about a number or citation: flag with `[TODO]` rather than guess.
- When a task splits into independent subtasks: decompose it and dispatch the subtasks to subagents in parallel (one message, multiple tool calls). Do not parallelize work that shares mutable state or has a true sequential dependency.
- When completed work establishes a durable decision or principle, or makes existing guidance obsolete: update the relevant project guidance. Replace superseded instructions, consolidate overlapping rules, and keep exploratory ideas in notes until established. Keep AGENTS.md concise and current, refresh affected human documentation, and record the change in the running log (`notes/log.md` if a wiki exists, else the README update log), linking to detailed rationale.
- After each meaningful operation: append one entry to `notes/log.md` as `## [YYYY-MM-DD] operation | description` (typed operation: `ingest` / `lint` / `strategy` / …); link to the phase plan and `[[decisions#...]]` rather than restating them. (Omit this rule if the project has no `notes/` wiki.)
- Periodically: lint the wiki — sweep for orphan pages, stale claims, and missing cross-references; fix or flag, and record the sweep as a `lint` log entry. (Omit if no wiki.)
- Single source of truth per fact: a number lives on one page and is linked, never copied. Never restate a result or a decision in a second location — link to it.
- At end of a completed task with a non-clean working tree: let the [`version-control`](../version-control.md) skill commit and push. Tag AI-assisted commits with `[AI]` if this repo documents that policy.
- Follow **Protected files and cleanup** for temporary/build artifacts. Finishing a task, successful compilation, or a request to commit does not authorize deleting files or directories.

**General principles** (optional house rules, adapted from [Karpathy's LLM-coding CLAUDE.md](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md); include only when the team wants them stated explicitly):

- **Think before coding.** State assumptions explicitly. If a request has multiple interpretations, present them — do not pick silently. If something is unclear, stop and name what's confusing before implementing.
- **Simplicity first.** Minimum code that answers the question. No speculative features, no abstractions for single-use scripts, no error handling for impossible inputs. If 200 lines could be 50, rewrite it.
- **Surgical changes.** Touch only what the task requires. Match the existing style. Do not refactor adjacent blocks or "improve" unrelated code. Remove task-related dead code when useful; file cleanup follows **Protected files and cleanup**. Preserve unrelated work. The test: every changed line traces directly to the user's request.
- **Goal-driven execution.** Convert tasks into verifiable goals before running them, and state a brief plan as `[step] → verify: [check]` for multi-step work. Strong success criteria let the agent loop until verified without re-asking.
```

**Step 4: Update any existing AGENTS.md and review the diff.** Apply the requested changes directly, preserve unrelated project guidance, and summarize the meaningful changes. Ask only when an unresolved conflict requires the user's decision.

### Notes for extending

- **Principles and rationale.** Read [general principles](references/general-principles.md) for writing/coding examples of the core task rule or for tailoring the optional house rules. Link to the rationale rather than copying it into generated AGENTS.md files.
- **Per-language profiles.** Factor language-specific convention blocks into `profiles/<lang>.md` files (R, Python, Stata, Julia). Loaded as Level-3 resources only when the language is present — keeps the main file short.
- **Multi-machine projects.** Link to environment or setup documentation for each machine; keep local paths and overrides in configuration.

### Generating a replication-package README (handoff to public)

For a public replication-package README with runnable commands, pinned versions, and outputs keyed to paper figures/tables, use the `replication-readme` skill when available.

## Task Decomposition and Subagent Delegation

Apply the template's independence rule: dispatch independent subtasks together and merge their results; keep shared mutable state and sequential dependencies in order. Delegation is useful for isolated, context-heavy work or when failures should be contained. Keep work in the main session if essential live context cannot be transferred.

Include the required context in each task brief:

```
Context: [1–2 sentences on the project and why this task matters]
Task: [Exactly what to do, with file paths]
Output: [Where to write results and in what format]
Constraints: [Any rules from AGENTS.md that apply]
```

## Automated Version Control

Use the [`version-control`](../version-control.md) skill for completion triggers, staging, checks, commits, and pushes. Record project-specific disclosure tags, commit-message conventions, required build steps, and paths excluded from staging in AGENTS.md. Keep the commit procedure in that skill rather than duplicating it in project instructions.
