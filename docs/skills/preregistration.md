---
name: preregistration
description: Use when the user is preparing to preregister an experiment, observational study, or analysis plan and wants a draft preregistration document scaffolded out. Walks the user through the standard fields (hypotheses, design, analysis plan, exclusion criteria) with prompts; produces a markdown draft compatible with OSF, AsPredicted, or a journal's pre-analysis plan format.
allowed-tools: Read, Bash
invocation: auto
---

Scaffold a draft preregistration document — hypotheses, design, analysis plan, exclusion criteria — in a format compatible with OSF, AsPredicted, or a journal's pre-analysis plan. The skill produces a draft; the user submits the actual preregistration.

---

## When to Use

- A study is **not yet run** and a registration is required (or strategically useful)
- A field experiment, RCT, or observational design needs a credible analysis plan attached before data collection
- A journal accepts (or requires) a pre-analysis plan as part of submission

Do **not** use this for a study that has already been run. That is a *post-registration*, a different artifact with different audit norms.

---

## Non-negotiable rules

1. Never lock in details the user has not actually decided. If two estimators are still on the table, keep both as alternatives with a decision rule, do not silently pick one.
2. Specify each analysis in enough detail that a reviewer could replicate it without further input. "Run a regression" is not a plan; "OLS of Y on T with controls X1–X5, robust SEs clustered at the firm level" is.
3. Always include falsifiability conditions — what observation would refute each hypothesis. A preregistration without falsifiability is just an outline.
4. Always include an exclusion-criteria section, even if "no exclusions" is the answer. Reviewers must see that the question was considered.

---

## Workflow

```
Choose format → Walk fields → Cross-check consistency → Emit draft → Final checklist
```

### Step 1 — Choose the format

One question: target format.

| Format | When to use |
|---|---|
| OSF Standard | Default; superset of most others |
| AsPredicted | Short, structured, fast |
| Journal PAP (e.g. *JPE*, *JM*) | Required by target journal |
| Custom | Lab- or PI-specific |

If unsure, default to OSF Standard.

### Step 2 — Walk the user through the fields (in batches)

Do not interrogate one field at a time. Group:

**Batch 1 — Study basics**
- Title
- Authors and affiliations
- Hypotheses (numbered, one per H)

**Batch 2 — Design**
- Design type (RCT, quasi-experiment, observational, simulation)
- Sample (population, recruitment, target N, power calc)
- Manipulations and measures (with operationalizations)

**Batch 3 — Analysis plan**
- Primary analysis (estimator, controls, SE structure, software)
- Secondary analyses (each fully specified)
- Robustness checks (and what would change the conclusion)

**Batch 4 — Data integrity**
- Exclusion criteria (with explicit thresholds)
- Missing-data handling
- Stopping rule (when do you stop collecting)

**Batch 5 — Transparency**
- Falsifiability conditions per hypothesis
- What is *not* preregistered (exploratory analyses)
- Deviations log: how deviations from this plan will be reported

### Step 3 — Cross-check internal consistency

Before emitting the draft, verify:

- Every hypothesis maps to ≥1 analysis in Batch 3
- Every analysis specifies estimator, sample, controls, and SE structure
- Sample size matches the power calculation (or flag the mismatch)
- Exclusion criteria have explicit thresholds, not vague rules

If a check fails, return to the user with the specific gap.

### Step 4 — Emit the draft

Format follows the chosen template. Always end with a metadata block:

```markdown
---
preregistration_format: OSF Standard
date_drafted: YYYY-MM-DD
authors: <names>
status: DRAFT — not yet submitted
---
```

The DRAFT marker is non-negotiable. Submission is the user's job.

### Step 5 — Final checklist

Print a one-page checklist of items the user must complete before submitting:

- [ ] Power calculation reviewed by co-author / advisor
- [ ] IRB approval obtained (or exempted)
- [ ] All hypotheses falsifiable (review with co-author)
- [ ] Analysis script (or skeleton) drafted
- [ ] Submitted to OSF / AsPredicted / journal PAP system
- [ ] Timestamp captured

---

## Companion skills

- [literature-review.md](literature-review.md) — produces the related-work section a prereg often cites
- [eda.md](eda.md) — for pilot data feeding the power calculation
- [revision-plan.md](revision-plan.md) — handles deviations after the fact

---

## Common failure modes

| Failure | Symptom | Fix |
|---|---|---|
| **Vague hypotheses** | "We expect X to influence Y" | Sign and threshold: "We expect Cohen's d ≥ 0.2 in favor of T" |
| **Open-ended analyses** | "We will run regressions" | Estimator, RHS variables, SE structure, software |
| **Missing exclusion thresholds** | "Drop outliers" | "Drop observations with z-score > 3 on Y" |
| **No stopping rule** | Sample grows until effect is significant | Pre-committed N from power calc, blinded to outcome |

---

## Notes for extending

- **Power calc integration.** Call out to `pwr` (R) or `statsmodels.stats.power` (Python) to compute required N from a target effect size and α. Wire the computed N back into Batch 2 of Step 2 so the consistency check in Step 3 has something to compare against.
- **DAGs for observational designs.** Add a section requiring the user to upload a DAG (DAGitty link or SVG) before the prereg is finalized. The DAG pins down the identification claim — without it, "controls" is just a list.
- **Progressive disclosure (Level-3 resources).** Format-specific templates (`templates/osf-standard.md`, `templates/aspredicted.md`, `templates/jpe-pap.md`, `templates/jm-pap.md`) live as Level-3 resources; only the chosen one is loaded. Keeps the skill itself short and avoids dumping all four template bodies into context when the user only needs one.
