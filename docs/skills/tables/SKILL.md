---
name: tables
description: Use when building, reformatting, or cleaning up a regression or descriptive table for publication — journal star cutoffs (JM / MS / AER / QJE / JCR), booktabs templates, variable labels, row/column layering, significant figures, alignment, and decluttering. Sibling to visualization; never re-runs the model, never invents Notes content, never changes a number.
allowed-tools: Read, Edit
invocation: auto
---
Format a regression or descriptive table — the figure's sibling artifact — for publication. The discipline is narrower than for figures: tables have one job (display numbers exactly), so the rules are about **formatting and presentation**, never re-running the model.

For figures, see [../visualization/SKILL.md](../visualization/SKILL.md). For the validity audit that should run before any table is drafted, see [report](../report/SKILL.md) → Pre-report Validity Check.

For the design rationale behind the "Design principles" checklist below — outcome labels, comparison-driven orientation, width allocation, the two-digit rule, alignment, and decluttering — see [references/design-principles.md](references/design-principles.md). It collects the standard sources (Schwabish, Gelman, Ehrenberg, Keith Head, booktabs).

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

- **Label, don't symbolize.** Self-explanatory word labels (`Ad spending`, not `ADSPND` or `β₁`); put the model symbol in parentheses *below* the label when notation must be preserved.
- **Name the substantive outcome in the header.** Use headings that identify what is measured, including the platform or object when needed: `ChatGPT sessions` rather than `Recorded sessions`. Put measurement qualifications, such as `recorded ChatGPT conversation sessions`, in the notes when supported by the source. Retain units and distinctions needed to interpret the values in the header.
- **Choose orientation around the intended comparison.** Comparing down aligned columns is a preference, not a rigid rule. When groups share outcomes and statistics, grouped columns can put groups side by side and eliminate repeated rows. Use stacked panels when width would compromise readability. Alternative specifications or time periods can run across columns; preserve meaningful sequences (looser→stricter sample, short→long horizon).
- **Allocate width before wrapping numbers or shrinking type.** Reserve enough room for complete estimates and intervals. First shorten or wrap row labels and headers without losing meaning, then adjust padding. If the table still does not fit, reconsider orientation or use stacked panels; preserve readable font sizes.
- **Give the reader a denominator.** Report a baseline — mean of the DV (overall or by group), or the control-group level — usually as a foot block, so a coefficient can be *sized*, not just signed: `0.056` against a `0.077` mean is a ~70% shift.
- **Two effective digits.** Choose units so coefficients carry 2–3 meaningful digits (avoid `0.000032` and `75432.8`); keep the decimal count *constant within a column*.
- **Align for scanning.** Right-align (or decimal-align) numbers, left-align text, header alignment matches its column. Sentence case — never Title Case or ALL CAPS.
- **Vertically center peer column headings.** When single-line and multiline headings share a header row, center them vertically within that row while preserving their horizontal alignment. Keep higher-level group headings in a separate row.
- **Declutter.** booktabs rules only (`\toprule` / `\midrule` / `\bottomrule`), thin and light; **no vertical rules, ever**; group rows with indented stubs and trimmed `\cmidrule(lr)`, not lines; white space over shading.
- **One job per row block.** SEs in parentheses directly under their coefficient; demote controls to a labeled panel or an auxiliary table rather than burying the headline rows.
- **Title above; notes form one paragraph.** Caption above the table, neutral. Order the notes by type within a single continuous paragraph, ending with the SE/clustering ("…in parentheses") key followed by the significance legend, when applicable. Additions slot in by type before that ending. See [The Notes block](#the-notes-block) below.

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

A table's notes display as **one continuous paragraph**, beginning with *Notes:* once. Use sentences to organize the content by type. Allow automatic line wrapping to the table width, but do not insert paragraph breaks, forced line breaks, bullets, or separate note items. In LaTeX, use one `\item` inside `tablenotes`; in HTML, use one `<p>`. The paragraph ends with the following information when applicable:

- **Final content — the significance legend.** `*** p<0.01, ** p<0.05, * p<0.1` (per the journal's cutoffs above). Keep it inline at the end of the paragraph when the table uses significance stars.
- **Immediately before the legend — the parenthetical key.** What the parentheses hold and the dispersion details: *what's in parentheses* (SE, t-stat, or CI), the *SE type* (robust / clustered / bootstrap, with reps), the *clustering level*, and the *number of clusters*. E.g. *"Robust standard errors clustered at the firm level (142 clusters) in parentheses."* It precedes the legend so readers learn what the parentheses contain before interpreting the stars. If there are no stars, this key ends the paragraph; omit it when there are no parenthetical statistics to explain.

Place the remaining content earlier in the same paragraph, in the order below. These categories organize sentences; they are not separate displayed paragraphs or headings. Use this menu to select what readers need to interpret the display; it is not a checklist to reproduce in every note. Avoid repeating information already clear in the caption, labels, or table body:

1. **Scope** — what the table reports and over what: estimator/method (OLS, 2SLS, logit, marginal effects), sample and population, time period, unit of observation, N (and any exclusions), and the dependent variable if it isn't in the caption.
2. **Specification** — fixed-effect and control sets included, weighting (sample weights, IPW), coefficient scale/transform (logs, standardized, percentage points), winsorizing/trimming, and the baseline or DV mean that *sizes* the coefficients.
3. **Definitions** — expand abbreviations and constructed measures; say what any reference line, cutoff, or shaded region means (ask the user; never guess — non-negotiable rule 3).
4. **Provenance & cross-refs** — `Source: …`; "See Table 3 / column (2)"; data vintage or replication pointer.

So "add a note that the sample drops 2020" slots into **Scope/Specification near the beginning**. "We now cluster at the state level" **replaces the existing parenthetical key** before the legend. A new abbreviation joins the **Definitions** sentences. When editing an existing notes block, insert content by type and retain a single paragraph, with the applicable inference key and legend at the end.

**Figures use the same note, written in the TeX caption/note.** The visualization skill keeps text *out* of the image, so a figure's "note" lives in the LaTeX float, not the PNG. Same menu as above, plus figure-specific items: what error bars or bands represent (95% CI, ±1 SE, bootstrap reps) and the SE type behind them; binning / bandwidth / kernel / smoother; what each series, color, or reference line is when not directly annotated; N and number of clusters; axis units or scale when non-obvious. See [`../visualization/SKILL.md`](../visualization/SKILL.md).

### Concise notes without defensive prose

Apply paper-writing's [scope guidance](../paper-writing/references/main-text.md#state-the-answer-directly) and [evidence-preserving voice](../paper-writing/references/academic-voice.md#preserve-the-evidence): add a qualification when omitting it would change the reader's interpretation, confidence in the result, or use of it. State the supported information directly. A note should make the display understandable on its own; fuller methodological justification and general limitations belong in methods or discussion.

Keep necessary definitions, sample restrictions, reference categories, and inference details. Remove stacked hedges, generic disclaimers, repeated limitations, and procedural narration that add no understanding. Prefer precise labels such as "Unadjusted association" when accurate over appending a general warning about causality. Retain a local caveat when this particular display would otherwise mislead; brevity is not a reason to conceal a material limitation.

Keep source checks and unresolved author questions outside the publication note. Resolve a missing detail from the available material or raise it with the author; do not fill the gap with speculative or defensive prose. For example, when supported, "Standard errors clustered at the firm level are in parentheses" needs no added account of how the wording was verified or why influence scores were not described.

### Inference wording for tables and figures

State the inference method and clustering level in reader-facing language, using the source output, code, or explicit user input as evidence. Apply the concise-note rule above when deciding how much detail to include.

- **Name clustering explicitly.** For firm-clustered SEs, write "Standard errors clustered at the firm level are in parentheses." A corresponding figure note can read "Error bars show 95% pointwise confidence intervals; standard errors are clustered by firm." Match the actual method, coverage, and cluster identifier; add the cluster count when supplied.
- **Separate observation and inference units.** Firm-month observations can have standard errors clustered by firm. State each where relevant; do not infer clustering from the row unit, fixed effects, treatment-assignment unit, or the name of a score array. Preserve all dimensions of multiway clustering.
- **Keep influence-score mechanics in methods unless needed to interpret the display.** "Firm influence scores" or "firm-cluster influence scores" does not replace the clustering statement. When the construction matters, describe the actual aggregation, such as "influence scores aggregated at the firm-cluster level." Preserve bootstrap method, resampling level, and pointwise versus simultaneous coverage when applicable; score-based procedures do not all imply conventional clustered SEs.
- **Resolve ambiguity during preparation.** "Firm influence scores" alone does not establish the inference method. Check the available source or raise the missing detail with the author outside the note. Do not invent clustering or other inference settings.

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

Keep each estimate attached to its source outcome, specification, sample, uncertainty, and applicable note. Use row/column identifiers in the working representation so reordering and relabeling preserve these associations.

### Step 3 — Apply the rules

Two layers, in order:

**Journal rules (mechanical):** header rows (`\toprule`, column titles, `\midrule`); coefficient rows with SE in parentheses (or below, per journal); significance stars per the journal's convention; summary rows (`\midrule`, then N, R²); `\bottomrule`; notes line (`\multicolumn{...}{l}{\textit{Notes:} ...}`).

**Design pass (presentation):** identify the comparison readers need to make, then choose row/column orientation or stacked panels to support it. Relabel cryptic variable names (ask the user when a name is ambiguous — never guess what an abbreviation means); name the substantive outcome in the header and move measurement qualifications into the notes. Set a consistent decimal count per column; allocate width for complete estimates and intervals, wrapping labels and headers before adjusting padding; demote controls to a panel if the headline rows are crowded. The design pass changes labels, layout, and decimal display — never the underlying values (see Non-negotiable rule 1).

### Step 4 — Validate

- Every coefficient in the source appears in the output (no silent drops)
- Every estimate remains paired with the correct outcome, specification, sample, uncertainty, and note after reordering or relabeling; an unchanged collection of numbers is insufficient
- Every star matches its p-value per the journal's convention
- Column count is consistent across all rows (no `&` mismatches)
- N preserved exactly
- Decimal count consistent within each column; no value silently re-rounded beyond the requested display precision
- Headers identify the substantive outcomes and necessary units; measurement qualifications in notes remain grounded in the source
- In the rendered table, peer column headings with different line counts are vertically centered within their shared row, preserve their horizontal alignment, and sit below any separate higher-level group-heading row
- At the intended display size, the chosen orientation supports the main comparison, estimates and intervals fit intact, and type remains readable
- Inference notes match the source method and clustering dimensions; observation units and influence-score mechanics do not substitute for an explicit clustering statement
- Notes retain information needed to interpret the display and omit redundant qualifications, generic disclaimers, and internal verification commentary
- Notes render as one paragraph with one "Notes:" label, no forced line breaks or separate items, and the applicable parenthetical key followed by the significance legend inline at the end

If a check fails, repair the formatting from the source and repeat the affected checks. If the source cannot resolve the discrepancy, report it outside the publication note and leave the output unverified. Do not emit a table as final until the checks pass; a more attractive layout cannot compensate for an incorrect association.

### Step 5 — Emit (compile-ready snippet)

```latex
% Requires booktabs and threeparttable. Keep only applicable note content.
\begin{table}[ht]
\centering
\begin{threeparttable}
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
\item \textit{Notes:} <scope, specification, definitions, source — in reading order, from source/user>. Standard errors clustered at the <level> are in parentheses. ${}^{*}\,p<0.1$, ${}^{**}\,p<0.05$, ${}^{***}\,p<0.01$.
\end{tablenotes}
\end{threeparttable}
\end{table}
```

---

## Notes for extending

- **Multi-panel tables.** Add a `panels` parameter that takes multiple input files and stacks them with panel labels (Panel A, Panel B). The header-detection logic in Step 2 already handles most of the work.
- **Output formats beyond LaTeX.** Markdown and HTML are mostly mechanical: same parse stage in Step 2, different emitter in Step 5. The design principles transfer unchanged; only the rule/alignment syntax differs.

---

## Report

Output uses the Quick Template — three labeled lines, **Definition** / **Description** / **Takeaway**. (For multi-section writeups, see [report](../report/SKILL.md).)

**Definition (measure):** Tables produced (count, target journal, output paths); whether all coefficients survived validation; whether the notes line came from source or user; which design-pass changes were made (relabels, re-ordering, decimal harmonization).
**Analyses:** Journal-specific rules applied (star cutoffs, SE placement, R² reporting); design rules applied; deviations from the source format that required user confirmation.
**Takeaway:** Whether the table is submission-ready or has flagged validation failures (silent coefficient drop, missing R², star/p-value mismatch) requiring human sign-off.
