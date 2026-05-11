---
name: tables
description: Use when reformatting a regression or descriptive table to a target journal's conventions — JM / MS / AER / QJE / JCR star cutoffs, booktabs templates, never-change-a-number rule. Sibling to visualization; never re-runs the model, never invents Notes content.
allowed-tools: Read, Edit
invocation: auto
---
Reformat a regression or descriptive table — the figure's sibling artifact — to a target journal's conventions. The discipline is narrower than for figures: tables have one job (display numbers exactly), so the rules are about **formatting**, never re-running the model.

For figures, see [visualization.md](visualization.md). For the validity audit that should run before any table is drafted, see [report.md](report.md) → Pre-report Validity Check.

---

## When to Use

- Converting raw `lm()` / `feols()` / `reg` / `stargazer` / `modelsummary` / `pandas.describe()` output into a publication-ready table
- Switching a paper's tables between journals during revision (e.g. *AER* → *JM*)
- Producing a final booktabs LaTeX block for the typesetter

Do **not** use this when the underlying numbers are still moving — format last, after the analysis is frozen.

---

## Non-negotiable rules

1. **Never change a number.** Coefficients, SEs, p-values, N, R² — round only to whatever the source provided unless the user explicitly asks for fewer decimals.
2. **Never re-run the regression.** The table is the input; this skill formats it. If the source lacks a quantity (e.g. adjusted R²), flag it; do not compute it.
3. **Never invent the "Notes" line.** Notes content must come from the source or from explicit user input.
4. **Stars must match the journal's convention exactly** (table below). 

---

## Journal-specific conventions

| Journal                            | Booktabs               | Star cutoffs                     | Notes                                                              |
| ---------------------------------- | ---------------------- | -------------------------------- | ------------------------------------------------------------------ |
| *Journal of Marketing*           | Yes, three-line header | `* p<.10, ** p<.05, *** p<.01` | Coefficients above SEs (in parentheses); 1 decimal for percentages |
| *Marketing Science*              | Yes                    | Same as JM                       | R²**and** adjusted R² always reported                      |
| *American Economic Review*       | Yes                    | `* p<.10, ** p<.05, *** p<.01` | SEs below coefficients                                             |
| *Quarterly Journal of Economics* | Yes                    | Same as AER                      | Extra panel separat                                                |

---

## Workflow

```
Identify journal + input → Parse → Apply rules → Validate → Emit
```

### Step 1 — Identify the target journal and input format

One question: target journal and input file (or pasted text). If both already provided, skip.

Source formats commonly seen:

- LaTeX from `stargazer` / `modelsummary` / `texreg`
- HTML from R Markdown / Quarto
- CSV / TSV from a spreadsheet export
- Plain-text regression output (parse line by line)

### Step 2 — Parse

Extract: variable names, coefficients, standard errors (or t-stats), N, R², F-stat, dependent variable label.

### Step 3 — Apply the journal's formatting rules

Build the output:

- Header rows (`\toprule`, column titles, `\midrule`)
- Coefficient rows with SE in parentheses (or below, per journal)
- Significance stars per the journal's convention
- Summary statistics rows (`\midrule`, then N, R²)
- `\bottomrule`
- Notes line (`\multicolumn{...}{l}{\textit{Notes:} ...}`)

### Step 4 — Validate

- Every coefficient in the source appears in the output (no silent drops)
- Every star matches its p-value per the journal's convention
- Column count is consistent across all rows (no `&` mismatches)
- N preserved exactly

If any check fails, **do not emit**; report the discrepancy and stop.

### Step 5 — Emit (compile-ready snippet)

```latex
\begin{table}[ht]
\centering
\caption{<from user>}
\label{tab:<from user>}
\begin{tabular}{lcc}
\toprule
 & (1) & (2) \\
\midrule
... & ... & ... \\
\midrule
N        & ... & ... \\
$R^2$    & ... & ... \\
\bottomrule
\end{tabular}
\begin{tablenotes}
\item \textit{Notes:} <from source / user>
\end{tablenotes}
\end{table}
```

---

## Notes for extending

- **Multi-panel tables.** Add a `panels` parameter that takes multiple input files and stacks them with panel labels (Panel A, Panel B). The header-detection logic in Step 2 already handles most of the work.
- **Output formats beyond LaTeX.** Markdown and HTML are mostly mechanical: same parse stage in Step 2, different emitter in Step 5.

---

## Report

Output uses the Quick Template — three labeled lines, **Definition** / **Description** / **Takeaway**. (For multi-section writeups, see [report.md](report.md).)

**Definition (measure):** Tables produced (count, target journal, output paths); whether all coefficients survived validation; whether the notes line came from source or user.
**Analyses:** Journal-specific rules applied (star cutoffs, SE placement, R² reporting); deviations from the source format that required user confirmation.
**Takeaway:** Whether the table is submission-ready or has flagged validation failures (silent coefficient drop, missing R², star/p-value mismatch) requiring human sign-off.
