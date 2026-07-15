---
name: ai-disclosure-block
description: Use when the user is preparing a paper, thesis, or replication package and needs an AI-use disclosure block that conforms to a target journal's policy. Inspects git history, CLAUDE.md, and any AI usage logs to populate the disclosure with concrete uses; does not invent uses that have no evidence.
allowed-tools: Read, Bash, Glob, Grep
user-invocable: true
invocation: confirm
---

Generate the AI-use disclosure block that increasingly many journals require, populated from real evidence in the project rather than boilerplate.

This skill is set with `user-invocable: true` so it appears as a slash command (`/ai-disclosure-block`) for quick access during manuscript prep.

---

## When to Use

- Finalizing a manuscript or replication package for submission
- A target journal has a specific "AI Use" section to fill in
- Reviewers or co-authors ask: "what did you actually use AI for?"

If the project has no AI-assisted commits, no `CLAUDE.md`, no usage log, and the user can't list any uses — there is nothing to disclose. Don't write a block.

---

## Non-negotiable rules

1. Every claim about AI use must be backed by evidence: a commit message tagged `[AI]`, a `CLAUDE.md`, an `ai-usage.log`, or the user's explicit statement during this session. Do not write "AI was used for X" without evidence X happened.
2. Disclose only what the user is comfortable disclosing. Generate a draft, then confirm each row before finalizing.
3. Avoid hedging defaults like "AI was used minimally" or "only for editing". They are red flags for reviewers when the actual use was deeper. Be specific.
4. Match the target journal's required format. If unknown, default to a comprehensive (JoM-style) disclosure that is the union of common requirements.

---

## Workflow

```
Identify journal → Gather evidence → Categorize → Draft block → Confirm with user
```

### Step 1 — Identify the target journal

One question: which journal (or "general/unknown")?

| Journal | Format |
|---|---|
| *Journal of Marketing* | Structured statement under "AI Use Disclosure" |
| *Marketing Science* | Short paragraph in acknowledgments |
| *Quantitative Marketing and Economics* | "Use of AI" section in supplementary materials |
| *Journal of Consumer Research* | Explicit list in the methods section |
| General / unknown | Comprehensive default (covers most requirements) |

### Step 2 — Gather evidence of AI use

```bash
# Tagged commits
git log --all --grep='\[AI\]' --pretty=format:'%h %s'

# Existing project memory
test -f CLAUDE.md && head -200 CLAUDE.md

# Usage log
test -f ai-usage.log && cat ai-usage.log

# AI-generated boilerplate left in outputs
grep -rn "Generated with Claude" --include="*.md" --include="*.qmd"
```

If nothing surfaces, ask the user directly to enumerate uses.

### Step 3 — Categorize

Bucket each use:

- **Literature search** — finding papers, building bibliographies
- **Code generation** — writing analysis or visualization code
- **Code review** — audit / debugging help
- **Data cleaning** — preprocessing, transformation
- **Text analysis** — sentiment, topic modeling, qualitative coding
- **Writing assistance** — drafting, editing, polishing prose
- **Other** — enumerate explicitly

### Step 4 — Draft the block

Default (general) format:

```markdown
## AI Use Disclosure

This research used the following AI tools:

| Tool | Version | Use | Verification |
|---|---|---|---|
| Claude Code (Sonnet 4.6) | 2025-Q4 | Wrote initial regression scripts; refactored data cleaning pipeline | All outputs cross-checked against Stata replication |
| Claude Code (Opus 4.7) | 2025-Q4 | Drafted methods section from analysis output | Manually revised; every empirical claim verified |

**What AI was NOT used for:** generating data; selecting the final sample; making theoretical claims; selecting which results to report.

**Validation procedures:**
- All AI-generated code was executed and outputs were inspected.
- All AI-generated citations were verified at Crossref.
- All AI-drafted prose was substantively revised by the authors before submission.

**Prompts and workflows:** AI prompts and the SKILL.md files invoked are archived in the replication package at `replication/ai-prompts/`.
```

### Step 5 — Confirm with the user

Print the draft. Ask the user to confirm each row. Edit per their instructions. Save to `disclosure.md` (or a path they specify).

---

## Companion skills

- [literature-review.md](literature-review.md) — output is a "Literature search" entry
- [llm-annotation.md](llm-annotation.md) — output is a "Text analysis" entry
- [revision-plan.md](revision-plan.md) — disclosure should be re-run after any major R&R

---

## Stopping criterion

If the only evidence is "I asked Claude one question once," do not generate a disclosure block. Have the user write a single sentence by hand. The block exists to be informative, not ceremonial.

---

## Notes for extending

- **Per-author disclosures.** When co-authors used AI to different extents, generate a per-author table rather than a single project-wide block.
- **Linked verification.** Auto-link to the pre-report validity check (see [report.md](report.md) → Pre-report Validity Check) and the literature-review DOI verification log (see [literature-review.md](literature-review.md) → Path B checklist) in the replication package, so reviewers can audit the validation claims rather than take them on faith.
