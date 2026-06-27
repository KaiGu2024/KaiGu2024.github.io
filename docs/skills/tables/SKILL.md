---
name: tables
description: Use when building, reformatting, or cleaning up a regression or descriptive table for publication — journal star cutoffs (JM / MS / AER / QJE / JCR), booktabs templates, variable labels, row/column layering, significant figures, alignment, and decluttering. Sibling to visualization; never re-runs the model, never invents Notes content, never changes a number.
allowed-tools: Read, Edit
invocation: auto
---
Format a regression or descriptive table — the figure's sibling artifact — for publication. The discipline is narrower than for figures: tables have one job (display numbers exactly), so the rules are about **formatting and presentation**, never re-running the model.

For figures, see [../visualization/SKILL.md](../visualization/SKILL.md). For the validity audit that should run before any table is drafted, see [../report.md](../report.md) → Pre-report Validity Check.

For the design rationale behind the "Design principles" checklist below — why labels beat symbols, why comparisons go down columns, the two-digit rule, alignment, and decluttering — see [references/design-principles.md](references/design-principles.md). It collects the standard sources (Schwabish, Gelman, Ehrenberg, Keith Head, booktabs).

---

## When to Use

- Converting raw `lm()` / `feols()` / `reg` / `stargazer` / `modelsummary` / `pandas.describe()` output into a publication-ready table
- Switching a paper's tables between journals during revision (e.g. *AER* → *JM*)
- Cleaning up a draft table's labels, precision, ordering, or layout for readability
- Producing a final booktabs LaTeX block for the typesetter

Do **not** use this when the underlying numbers are still moving — format last, after the analysis is frozen.

---

## Non-negotiable rules

1. **Never change a number.** Coefficients, SEs, p-values, N, R² — round only to whatever the source provided unless the user explicitly asks for fewer decimals.
2. **Never re-run the regression.** The table is the input; this skill formats it. If the source lacks a quantity (e.g. adjusted R²), flag it; do not compute it.
3. **Never invent the "Notes" line.** Notes content must come from the source or from explicit user input.
4. **Stars must match the journal's convention exactly** (table below).

---

## Design principles — the short list

A table is read, not glanced at: it exists to let the reader find an exact number and compare it to its neighbor. Every rule below serves one of those two jobs. Full rationale and sources in [references/design-principles.md](references/design-principles.md).

- **Label, don't symbolize.** Self-explanatory word labels (`Ad spending`, not `ADSPND` or `β₁`); put the model symbol in parentheses *below* the label when notation must be preserved. With 4–8 columns there is room for words.
- **Put the comparison down a column.** Readers compare numbers vertically far better than across a row — arrange the table so the contrast you want them to see runs down a column. Columns are alternative specifications; time runs across columns. When the specs form a natural sequence (looser→stricter sample, short→long horizon), order the columns along it so the result reads as a gradient. If the headline comparison is forced across a row (single coefficient over sample/subgroup columns), don't restructure — bold or shade the cells that carry the result.
- **Give the reader a denominator.** Report a baseline — mean of the DV (overall or by group), or the control-group level — usually as a foot block, so a coefficient can be *sized*, not just signed: `0.056` against a `0.077` mean is a ~70% shift.
- **Two effective digits.** Choose units so coefficients carry 2–3 meaningful digits (avoid `0.000032` and `75432.8`); keep the decimal count *constant within a column*.
- **Align for scanning.** Right-align (or decimal-align) numbers, left-align text, header alignment matches its column. Sentence case — never Title Case or ALL CAPS.
- **Declutter.** booktabs rules only (`\toprule` / `\midrule` / `\bottomrule`), thin and light; **no vertical rules, ever**; group rows with indented stubs and trimmed `\cmidrule(lr)`, not lines; white space over shading.
- **One job per row block.** SEs in parentheses directly under their coefficient; demote controls to a labeled panel or an auxiliary table rather than burying the headline rows.
- **Title above; notes are a typed, bottom-anchored block.** Caption above the table, neutral. The notes below are ordered by note *type*, with two fixed anchors at the foot — the significance legend on the very last line and the SE/clustering ("…in parentheses") key just above it. Additions slot in by type; they never append past those anchors. See [The Notes block](#the-notes-block) below.

---

## Journal-specific conventions

| Journal                            | Booktabs               | Star cutoffs                     | Notes                                                              |
| ---------------------------------- | ---------------------- | -------------------------------- | ------------------------------------------------------------------ |
| *Journal of Marketing*           | Yes, three-line header | `* p<.10, ** p<.05, *** p<.01` | Coefficients above SEs (in parentheses); 1 decimal for percentages |
| *Marketing Science*              | Yes                    | Same as JM                       | R² **and** adjusted R² always reported                      |
| *American Economic Review*       | Yes                    | `* p<.10, ** p<.05, *** p<.01` | SEs below coefficients                                             |
| *Quarterly Journal of Economics* | Yes                    | Same as AER                      | Extra panel separator                                              |

---

## The Notes block

A table's notes are a **typed, ordered block, not a running log** — so the question "where does this new note go?" has a deterministic answer, and it is almost never "at the end." The foot of the block is reserved for two anchors readers expect to find there:

- **Last line — the significance legend.** `*** p<0.01, ** p<0.05, * p<0.1` (per the journal's cutoffs above). It is a fixed reading key; it always sits on the very bottom line, alone.
- **Second-to-last — the parenthetical key.** What the parentheses hold and the SE type/clustering: *"Standard errors clustered at the \<level\> in parentheses."* It precedes the legend because the stars are computed from these SEs — the reader has to know what the parentheses contain before the stars decode to anything.

Everything else is inserted *above* those two anchors, in reading order:

1. **Scope** — estimator, sample, unit of observation, dependent variable (if not already stated in the caption).
2. **Specification** — fixed effects, weighting, transformations, which controls are included.
3. **Definitions** — expand abbreviations and constructed measures (ask the user; never guess — non-negotiable rule 3).
4. **Cross-references / source** — `Source: …`; "See Table 3 for …".

So "add a note that the sample drops 2020" slots into **Scope/Specification near the top** — not after the legend. "We now cluster at the state level" **replaces the existing parenthetical key** in the second-to-last slot rather than adding a line. And a new abbreviation joins the **Definitions** group, not the bottom. When editing an existing notes block, find the anchor lines first, then insert relative to the typed groups above them — appending blindly is the common error this rule exists to prevent.

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

### Step 3 — Apply the rules

Two layers, in order:

**Journal rules (mechanical):** header rows (`\toprule`, column titles, `\midrule`); coefficient rows with SE in parentheses (or below, per journal); significance stars per the journal's convention; summary rows (`\midrule`, then N, R²); `\bottomrule`; notes line (`\multicolumn{...}{l}{\textit{Notes:} ...}`).

**Design pass (presentation):** relabel cryptic variable names to readable labels (ask the user when a name is ambiguous — never guess what an abbreviation means); set a consistent decimal count per column; order rows so the intended comparison runs down a column; demote controls to a panel if the headline rows are crowded. The design pass changes labels, ordering, and decimal display — never the underlying values (see Non-negotiable rule 1).

### Step 4 — Validate

- Every coefficient in the source appears in the output (no silent drops)
- Every star matches its p-value per the journal's convention
- Column count is consistent across all rows (no `&` mismatches)
- N preserved exactly
- Decimal count consistent within each column; no value silently re-rounded beyond the requested display precision

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
\begin{tablenotes}[flushleft]
\small
\item \textit{Notes:} <scope, specification, definitions, source — in reading order, from source/user>
\item Standard errors clustered at the <level> in parentheses.        % parenthetical key — second-to-last
\item ${}^{*}\,p<0.1$, ${}^{**}\,p<0.05$, ${}^{***}\,p<0.01$          % significance legend — ALWAYS the last line
\end{tablenotes}
\end{table}
```

---

## Notes for extending

- **Multi-panel tables.** Add a `panels` parameter that takes multiple input files and stacks them with panel labels (Panel A, Panel B). The header-detection logic in Step 2 already handles most of the work.
- **Output formats beyond LaTeX.** Markdown and HTML are mostly mechanical: same parse stage in Step 2, different emitter in Step 5. The design principles transfer unchanged; only the rule/alignment syntax differs.

---

## Report

Output uses the Quick Template — three labeled lines, **Definition** / **Description** / **Takeaway**. (For multi-section writeups, see [../report.md](../report.md).)

**Definition (measure):** Tables produced (count, target journal, output paths); whether all coefficients survived validation; whether the notes line came from source or user; which design-pass changes were made (relabels, re-ordering, decimal harmonization).
**Analyses:** Journal-specific rules applied (star cutoffs, SE placement, R² reporting); design rules applied; deviations from the source format that required user confirmation.
**Takeaway:** Whether the table is submission-ready or has flagged validation failures (silent coefficient drop, missing R², star/p-value mismatch) requiring human sign-off.
