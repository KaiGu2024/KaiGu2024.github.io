---
name: agent-configuration
description: Use when configuring Claude Code for a research project — installing the CLI, writing CLAUDE.md (with the research-specific Data Provenance, Citation Policy, and AI Disclosure sections), customizing the status line, managing context with /compact, and delegating to subagents. Inspects the project directory to populate CLAUDE.md sections from real evidence rather than boilerplate.
allowed-tools: Read, Bash, Glob, Grep
invocation: manual
---

## Installation (Windows)

**Prerequisites — Git for Windows:**

Claude Code's installer requires Git for Windows (provides the Unix tools it depends on).

1. Download from https://git-scm.com/download/win and run the installer.
2. On the *Adjusting your PATH* screen, select **"Git from the command line and also from 3rd-party software"** (the default).
3. Complete the install, then open a new PowerShell window.

**Install Claude Code:**

```powershell
irm https://claude.ai/install.ps1 | iex
```

This handles PATH registration automatically. Verify with `claude --version`.

**Fallback (if you prefer npm):**

```powershell
npm install -g @anthropic-ai/claude-code
```

If `claude` is not found after install, add the npm bin dir to PATH:

```powershell
$npmBin = "$(npm config get prefix)"
$current = [Environment]::GetEnvironmentVariable("Path", "User")
if ($current -notlike "*$npmBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$current;$npmBin", "User")
}
```

Then restart the terminal and verify with `claude --version`.

---

## CLAUDE.md

`CLAUDE.md` is loaded into every session and survives `/compact`. It is the one place for rules that must persist — put anything here that you would otherwise need to repeat after a context reset.

**What belongs in CLAUDE.md:**

- Project layout (which directories hold what)
- Tool constraints (e.g., which compiler to use, path overrides)
- Non-obvious conventions (naming, output locations, forbidden actions)
- Verification commands (how to test that the code/analysis is correct)
- Subagent inventory — names, purposes, and the scope constraints to re-state when spawning each one. Spawned subagents do not inherit CLAUDE.md, so the main agent needs the canonical text here to paste into every subagent brief.

**What does not belong:**

- Things derivable from the code (don't describe what the code already says)
- Temporary task state (use task notes or a separate scratchpad)
- Generic best practices (the model already knows these)

**Compaction survival test:** Read each line in CLAUDE.md and ask "if this disappeared after `/compact`, would the agent make a wrong decision?" If no, cut it.

### Research-project CLAUDE.md (mandatory sections)

Generic CLAUDE.md guidance is not enough for a research project. Reproducibility, citation integrity, and AI disclosure are research-specific concerns that the model will not enforce on its own — they have to be written down. **Three sections are non-negotiable** for any dissertation, paper replication, or working-paper repo:

1. **Data Provenance.** Sources, access (license, embargoes, how to re-obtain raw data), versioning (how data versions are tracked). Research projects without data lineage become unreproducible the moment the original author leaves. If the directory has no data folder yet, leave the section as a checklist for the user to fill in — but include the heading.
2. **Citation Policy.** Every cited paper must have a verified DOI in `references.bib`. Reference the [`literature-review`](literature-review.md) skill as the verification path — Path A (OpenAlex search → Crossref DOI verification) for indexed work, Path B (post-hoc DOI / title / author / year / venue checklist) for grey literature.
3. **AI Disclosure policy.** Track AI-assisted commits with the `[AI]` tag in commit messages. Reference the `ai-disclosure-block` skill for end-of-pipeline disclosure generation. Even a project that does "minimal" AI use needs this section so the policy is visible to co-authors and reviewers.

### Generating a research CLAUDE.md (workflow)

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

# Existing CLAUDE.md
test -f CLAUDE.md && head -200 CLAUDE.md
```

Capture: dominant language, data folder location (if any), pipeline entrypoint, presence of pre-commit / CI / Quarto, any existing CLAUDE.md.

**Step 2 — Ask up to 2 questions.** Only what cannot be inferred:

1. What is the research question this project addresses? (one sentence)
2. What is the target output? (paper, dissertation chapter, replication package, working paper)

Skip if already answered. **Never ask about anything readable from the directory.**

**Step 3 — Emit** (skip irrelevant sections for empty projects, but keep the headings as scaffolding):

```markdown
# CLAUDE.md — <project-name>

## Project Overview
<one paragraph from Step 2>

## Tools and Languages
<from Step 1: e.g., "R 4.4 (primary), Python 3.11 (text analysis only)">

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
- Use the [`literature-review`](literature-review.md) skill (Path B verification checklist) before committing the bibliography.

## AI Disclosure
- Track AI-assisted commits with the `[AI]` tag in commit messages.
- For final outputs, generate a disclosure block with the `ai-disclosure-block` skill.

## Conventions for Claude Code
- When writing new analysis: produce both the code and the output it generates.
- When proposing a method change: state which result(s) it would change before editing.
- When uncertain about a number or citation: flag with `[TODO]` rather than guess.
```

**Step 4 — Diff against any existing CLAUDE.md.** Do **not** overwrite. Show a unified diff and ask the user to approve, reject, or merge per section.

### Notes for extending

- **Per-language profiles.** Factor language-specific convention blocks into `profiles/<lang>.md` files (R, Python, Stata, Julia). Loaded as Level-3 resources only when the language is present — keeps the main file short.
- **Multi-machine projects.** Add a section noting machine-specific paths (HPC vs. laptop) when the project runs in both places.

### Generating a replication-package README (handoff to public)

The CLAUDE.md above is for **active development**. The replication-package **README.md** is for the **public handoff** — a reviewer or future replicator should be able to clone the repo and run the pipeline end-to-end. Different audience, different discipline.

Use this when preparing a replication package for a paper submission, JoP / Code Ocean upload, or dissertation appendix. For a project still under active development, use the CLAUDE.md generator above instead.

#### Non-negotiable rules

1. **Every command in the README must be one a reviewer can run verbatim** (no placeholders without an explicit `<...>` and instructions for what to substitute).
2. **Every input file referenced must exist in the package or be accompanied by access instructions.**
3. **Software versions must be pinned.** "R 4.4" is acceptable; "R" alone is not.
4. **The Outputs section must list every figure and table the package produces, keyed to the paper.**

#### Workflow

```
Inspect package → Identify run order → Identify outputs → Emit README → Emit TODO list
```

**Step 1 — Inspect the package.**

```bash
ls -la
fd -e R -e py -e do -e jl -e qmd -e Rmd | head -20
ls Makefile master.do _quarto.yml run_all.py 2>/dev/null
ls renv.lock requirements.txt environment.yml conda-lock.yml Pipfile.lock 2>/dev/null
ls -d data raw_data data/raw data/processed 2>/dev/null
```

Capture: language(s), entrypoint(s), lock file(s), data folder structure, presence of `figures/` and `tables/` output folders.

**Step 2 — Identify the run order.** Read the entrypoint (Makefile / `master.do` / `_quarto.yml` / driver script) and extract the canonical sequence. If there is no entrypoint, walk the data flow manually.

**Step 3 — Identify the outputs.** Find every script that writes to `figures/`, `tables/`, or equivalent. Record: filename, the script that produces it, and (if findable) the figure/table number in the paper. If the paper-to-output mapping is not in the code, leave a TODO for the user.

**Step 4 — Emit the README.** Use this template (skip sections that do not apply, but keep the headings as scaffolding so the user knows what is missing):

```markdown
# Replication Package: <Paper Title>

**Authors:** <names>
**Last updated:** <date>

## Overview
<one paragraph: what the paper does, what this package replicates>

## Software Requirements
- <Language> <version>, with the following packages: <list, or "see lock file">
- <Other tools: pdflatex, GNU make, Stata 18, etc.>

Reproducibility tested on: <OS / hardware>.

## Data
| File | Source | Access | License |
|---|---|---|---|
| `data/raw/...` | <provenance> | <how to obtain> | <license / restrictions> |

If any data file cannot be redistributed, the table makes that explicit.

## Directory Layout
<tree -L 2, with one-line description per top-level dir>

## How to Reproduce
\```bash
# 1. Install dependencies
<command, derived from lock file>

# 2. Run the full pipeline
<command, derived from entrypoint>
\```

Approximate runtime: <hours/minutes on what hardware>.

## Outputs
| File | Script | Paper reference |
|---|---|---|
| `figures/fig1.pdf` | `scripts/02_descriptive.R` | Figure 1 |
| `tables/tab1.tex` | `scripts/03_main_results.R` | Table 1 |

## AI Disclosure
<populated from the ai-disclosure-block skill, or TODO>

## Citation
<BibTeX block for the paper>

## License
<MIT / CC-BY-4.0 / etc. for the code; data may differ>

## Contact
<email / GitHub issues link>
```

**Step 5 — Emit a TODO list.** After writing the README, print every section that contains a `<...>` placeholder or `TODO`. The user fills these by hand — the goal is to make the gaps visible, not paper over them.

#### Notes for extending

- **Language-specific install blocks.** Factor `install/r.md`, `install/py.md`, `install/stata.md` as Level-3 resources and load only the relevant ones.
- **Figure-to-paper map.** If the paper exists as a `.tex` file in the package, parse `\caption{...}` blocks to auto-fill the paper-reference column.

```markdown
# Project: [Name]

## Layout
- `data/raw/`       — immutable source files, never overwrite
- `data/cleaned/`   — outputs of cleaning scripts
- `code/`           — all scripts; one file per pipeline stage
- `writing/`        — draft text, LaTeX source

## Constraints
- Never edit files in `data/raw/`
- Compile with: [exact compile command]
- Output figures to `output/figures/`

## Subagents
- `data-loader` — pulls and harmonizes raw files into `data/cleaned/`.
  Re-state in every brief: "do not look in `..` or modify anything in `data/raw/`".
- `figure-builder` — produces figures in `output/figures/`.
  Re-state in every brief: "house style is Kieran Healy; one chart per file; never write outside `output/figures/`".

## Verification
- Run `make test` to check pipeline end-to-end
```

---

## Custom Status Line

The status line appears at the bottom of the Claude Code terminal and shows live session state. It runs as a script that Claude Code polls — you describe what you want and the agent writes and wires the script for you.

**Initial prompt (paste into a fresh session):**

```
Please create a custom status line for Claude Code. I want it
to show my context-window usage as a horizontal progress bar
followed by the exact percentage as a number. The bar should
be colored based on usage:

  - green when usage is below 50%
  - yellow when usage is between 50% and 70%
  - red when usage is above 70%

Also show the model name on the left and the cost so far on
the right. When you are done, write the script, wire it into
~/.claude/settings.json, and tell me where you saved it so I
can open it later.
```

**Iteration prompts (one line each, same session):**

```
Make the bar twice as long.
```

```
Add an emoji for each zone (✅ / 🟡 / 🚨).
```

```
Show the git branch at the right instead of cost.
```

```
Use a darker shade of yellow — the current one is hard to read.
```

Each request is one line. You do not need to touch the script yourself — the agent edits and re-wires it each time.

**Rule of thumb:** Include context-window usage in every long research session. When it hits ~70%, plan a `/compact` or delegate remaining work to a subagent.

---

## Context Management

The context window fills as the session grows. When it reaches capacity, responses degrade silently before erroring.

**Signs of context pressure:**

- Agent stops following rules it followed earlier
- Responses become shorter and less specific
- The agent "forgets" files or constraints it previously knew

**`/compact` — when and how:**

Run `/compact` before context pressure causes degradation (~70–80% usage). Always include a preservation prompt:

```
/compact Preserve: (1) the current task and what's done vs. remaining,
(2) all rules from CLAUDE.md, (3) the output file paths agreed on.
Do not summarize code that hasn't changed.
```

Without a preservation prompt, compaction may lose the task state and force you to re-explain the situation.

---

## Subagent Delegation

Delegate to a subagent when a subtask is:

- **Isolated** — it doesn't need the main session's full context
- **Context-heavy** — running it inline would fill the window before the main task finishes
- **Risky** — you want failures contained and recoverable

**What makes a good subagent prompt:**

A subagent starts cold. It has no memory of your session. Write its prompt as if briefing someone who just walked in:

```
Context: [1–2 sentences on the project and why this task matters]
Task: [Exactly what to do, with file paths]
Output: [Where to write results and in what format]
Constraints: [Any rules from CLAUDE.md that apply]
```

**When not to delegate:** If the subtask needs information that only exists in the current conversation (live variable values, intermediate results held in memory), keep it in the main session.

---

## Skill Invocation Contract

Every skill in `docs/skills/` declares an `invocation:` field in its frontmatter. It controls when Claude is allowed to fire the skill:

| Value | Behavior |
|---|---|
| **`auto`** | Fires whenever the description matches user intent. No confirmation. Default for skills with no side effects (drafting, analysis, reading, formatting). |
| **`confirm`** | Fires when the description matches *and* asks one yes/no before acting. Required for skills with side effects: commits, external writes, paid LLM calls. |
| **`manual`** | Never auto-fires on description match alone. Runs only when the user types the skill name explicitly (`/skill-name`, "use the X skill", or directly references the skill). For heavyweight or one-shot setup skills. |

**Caveat — convention, not infrastructure.** Claude Code's skill loader does not enforce this field. Claude reads it and respects it. If a skill marked `confirm` fires without confirmation, that is a bug in Claude's behavior, not the loader's.

**Current assignments:**

- **`manual`** — `agent-configuration` (one-shot setup), `paper-review` (6-agent run, expensive)
- **`confirm`** — `version-control`, `ai-disclosure-block`, `analysis-cleanup`, `llm-annotation`, `web-scraping` (each has commits, external writes, or paid API calls)
- **`auto`** — everything else (drafting, analysis, reading, formatting)

**Default if missing:** `auto`. Matches current loader behavior so older skills without the field keep working.

**Relationship to `user-invocable: true`.** A few skills (`ai-disclosure-block`, `revision`, `slide`) carry a legacy `user-invocable: true` field. The two fields are complementary — `user-invocable` exposes the skill for direct invocation; `invocation:` controls Claude's auto-fire decision. A skill can be both `user-invocable: true` and `invocation: auto` (most permissive). Eventually consider consolidating to one field; no urgency.

---

## Automated Version Control

The [`version-control`](version-control.md) skill auto-fires when end-of-task is signaled and the working tree is non-clean. It infers the repo's commit-message style from the last 10 commits, runs project-specific build hooks (e.g., the CV rebuild when `code/cv.tex` changes), commits, and pushes. You do not re-state which files belong, what the message should say, or whether the build artifact is current.

**Why a skill, not a `Stop` hook.** A hook would fire after every assistant turn, but most turns are not commit-worthy — debugging steps, exploratory edits, half-finished refactors. A skill defers to model judgment about *whether* this is a good checkpoint, while remaining trivial to invoke explicitly when you want it ("commit this", "save", "push").

**Per-project tuning.** Record any of the following in the project's CLAUDE.md so the skill picks them up automatically:

- `[AI]` disclosure tag policy (research repos that track AI-assisted commits)
- Conventional-commit prefixes if the repo uses them
- Pre-commit build steps tied to specific file changes (LaTeX → PDF, Quarto render, figure regeneration)
- Sensitive paths to never stage (data files, credentials, large binaries)

The skill reads CLAUDE.md before committing and respects whatever is documented there. Conventions that are not written down will not be applied.

**What the skill will not do:**

- Open pull requests (`gh pr create` is a separate, explicit step)
- Bypass pre-commit hooks (`--no-verify`)
- Amend a previous commit after a hook failure (creates a new commit instead — `--amend` would silently modify the wrong commit)
- Force-push to `main`
- Stage files indiscriminately (`git add -A` / `git add .` are forbidden because they sweep in `.env`, credentials, and untracked binaries)

**Invocation.** Auto-triggered, but you can also be explicit: "commit", "push", "save the current state", "snapshot this", "ship it". If the working tree is clean or the changes look mid-task, the skill asks before firing rather than guessing.
