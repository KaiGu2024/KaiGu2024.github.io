---
name: paper-review
description: Run a 6-agent pre-submission referee report for an academic paper targeting a specified journal
allowed-tools: Read, Bash, Glob, Grep
invocation: manual
---

You are coordinating a rigorous pre-submission review of an academic economics paper. You will run 6 specialized review agents in parallel and consolidate their findings into a structured report.

The six agent prompts live in `agents/` — one file per role. Read each file at the moment you spawn its subagent; do not pre-load them. They are independent prompts and the dispatcher does not need their content.

---

## Phase 1: Parse Arguments and Discover the Paper

Parse `$ARGUMENTS` as follows:

- The recognized journal names are:
  - **Top-5 economics**: `American Economic Review`, `Quarterly Journal of Economics`, `Journal of Political Economy`, `Econometrica`, `Review of Economic Studies`
  - **Field top economics**: `American Economic Journal`, `Economic Journal`, `RAND Journal of Economics`
  - **Quantitative marketing**: `Journal of Marketing Research`, `Marketing Science`, `Quantitative Marketing and Economics`
  - **Information systems**: `Information Systems Research`, `MIS Quarterly`
  - (case-insensitive; users can add further journals by editing this list in the skill file)
- Match by longest-prefix: try to match the start of `$ARGUMENTS` against each recognized journal name (case-insensitive), preferring the longest matching name. If a match is found, that is the **target journal** and the remainder of `$ARGUMENTS` is the **file path**. This handles multi-word names like `Marketing Science paper.tex` correctly.
- If no journal name prefixes `$ARGUMENTS`, treat the entire string as a file path and set the target journal to `top-field` (meaning the review applies high general standards without a specific journal persona).
- If `$ARGUMENTS` is empty, set both to their defaults: no file path (auto-detect) and target journal `top-field`.

Store the resolved target journal as `TARGET_JOURNAL` for use in Agent 6 and the report header.

If a file path was provided, use it as the main LaTeX file. Otherwise, auto-detect:

1. Use Glob with pattern `**/*.tex` to list all .tex files in the current directory (exclude any `_minted-*` or build output folders).
2. Identify the **main document**: the .tex file that contains `\documentclass` or `\begin{document}`. Read each candidate briefly if needed.
3. Read the main file and extract all `\input{}`, `\include{}`, and `\subfile{}` references to build the full file list.
4. Read all component .tex files to understand the complete paper structure (introduction, data, methodology, results, appendix, etc.).
5. Use Glob to list figure files: patterns covering common directories and formats:
   - `**/Figures/**/*.pdf`, `**/figures/**/*.pdf`, `**/Figure/**/*.pdf`, `**/figure/**/*.pdf`
   - `**/Figures/**/*.png`, `**/figures/**/*.png`, `**/Figure/**/*.png`, `**/figure/**/*.png`
   - `**/Figures/**/*.eps`, `**/figures/**/*.eps`, `**/Figure/**/*.eps`, `**/figure/**/*.eps`
   - `**/Figures/**/*.jpg`, `**/figures/**/*.jpg`, `**/Figure/**/*.jpg`, `**/figure/**/*.jpg`
   - `**/Figures/**/*.jpeg`, `**/figures/**/*.jpeg`, `**/Figure/**/*.jpeg`, `**/figure/**/*.jpeg`
   - `**/Figures/**/*.svg`, `**/figures/**/*.svg`, `**/Figure/**/*.svg`, `**/figure/**/*.svg`
   - Root-level: `*.pdf`, `*.png`, `*.eps`, `*.jpg`, `*.jpeg`, `*.svg`
   - Exclude: `**/_minted-*/**`, `**/build/**`, `**/output/**`, `**/.git/**`
6. Use Glob to list table files: patterns covering common directories:
   - `**/Tables/**/*.tex`, `**/tables/**/*.tex`, `**/Table/**/*.tex`, `**/table/**/*.tex`
   - Root-level: `*table*.tex`, `*Table*.tex`
   - Exclude: `**/_minted-*/**`, `**/build/**`, `**/output/**`, `**/.git/**`

Record:

- Full path of each .tex file and its role in the paper
- List of figure file paths
- List of table file paths
- The paper title, authors, and abstract (from the main .tex file)

**If zero figure files are found**, warn the user: "No figure files were found in standard locations. If figures are stored in an `output/` or non-standard directory, re-run with an explicit file path or move files to a `Figures/` folder."

**If zero table files are found**, warn the user: "No table .tex files were found in standard locations. Tables may be stored in an `output/` or non-standard directory. Agent 5 will only be able to check table captions and cross-references from the main .tex files."

---

## Phase 2: Launch 6 Review Agents in Parallel

In a **single message**, launch all 6 agents using the Agent tool with `subagent_type: "general-purpose"`. Each agent reads the paper files independently. Pass the complete list of .tex file paths, figure paths, and table paths to each agent in its prompt. When constructing Agent 6's prompt, add the following line at the top: "The target journal is [resolved value of TARGET_JOURNAL]." Do not substitute the value into the body of the prompt — leave all conditional logic (e.g., "If TARGET_JOURNAL is top-field...") intact so Agent 6 can reason with it.

| # | Role | Prompt file |
|---|------|-------------|
| 1 | Spelling, Grammar & Academic Style | `agents/copy-editor.md` |
| 2 | Internal Consistency & Cross-Reference Verification | `agents/consistency.md` |
| 3 | Unsupported Claims & Identification Integrity | `agents/claim-discipline.md` |
| 4 | Mathematics, Equations & Notation | `agents/math.md` |
| 5 | Tables, Figures & Documentation | `agents/tables-figures.md` |
| 6 | Contribution Evaluation (Adversarial Referee) | `agents/contribution.md` |

For each agent, read the prompt file from `agents/<name>.md`, append the file-list block at the end (the prompt files end with `[LIST ALL TEX FILE PATHS HERE]` and, for agents 2 and 5, `[LIST FIGURE PATHS]` and `[LIST TABLE PATHS]`), and dispatch.

---

## Phase 3: Consolidate and Save

**Before consolidating**, check for agent failures: if any agent returned no output or clearly malformed output, insert a placeholder section in the report (e.g., "## 4. Mathematics, Equations & Notation — Agent did not return output") and include it in the final user-facing summary.

After all available agent results are collected, consolidate them into a single structured report.

**Before saving**, check whether `PRE_SUBMISSION_REVIEW_[YYYY-MM-DD].md` already exists in the current directory. If it does, append `-v2` (or `-v3`, etc.) to avoid overwriting.

Save the report to:

`PRE_SUBMISSION_REVIEW_[YYYY-MM-DD].md`

where `[YYYY-MM-DD]` is today's date.

**Report structure:**

```markdown
# Pre-Submission Referee Report

**Paper**: [Title]
**Authors**: [Authors]
**Date**: [Today's date]
**Review Standard**: [TARGET_JOURNAL — if top-field, write "Leading Field Journal"; otherwise write the specific journal name]

---

## Overall Assessment

[3–4 sentences synthesized as follows: (1) what the paper does — from Agent 6 Part 1; (2) its principal strength — from Agent 6 Part 1 contribution rating; (3) the single most critical issue — the top CRITICAL item from the Priority Action Items list below. Do not introduce judgments not already present in the agent outputs.]

**Preliminary Recommendation**: [Copy exactly from Agent 6 Part 5 — do not paraphrase]

---

## 1. Contribution & Referee Assessment

[Agent 6 output]

---

## 2. Unsupported Claims & Identification Integrity

[Agent 3 output]

---

## 3. Internal Consistency & Cross-Reference Verification

[Agent 2 output]

---

## 4. Mathematics, Equations & Notation

[Agent 4 output]

---

## 5. Tables, Figures & Documentation

[Agent 5 output]

---

## 6. Spelling, Grammar & Style

[Agent 1 output, preserving its structure]

---

## Priority Action Items

Each agent has tagged its findings as `[CRITICAL]`, `[MAJOR]`, or `[MINOR]`. Collect all tagged items across agents and rank them here using the following triage hierarchy: `[CRITICAL]` items from Agent 3 and Agent 6 Part 2 first, then `[CRITICAL]` from Agent 6 Part 3, then remaining `[CRITICAL]` items by agent order, then all `[MAJOR]` items, then `[MINOR]` items.

**CRITICAL** (must fix — these could cause desk rejection or major referee objections):
1. ...
2. ...
3. ...

**MAJOR** (should fix — will likely be raised by referees):
4. ...
5. ...
6. ...
7. ...

**MINOR** (polish — improves paper quality):
8. ...
9. ...
10. ...
```

After saving, report to the user:

1. The path to the saved report
2. The preliminary recommendation from Agent 6
3. The top 5 priority action items
4. How many issues were flagged in each category (counts)
