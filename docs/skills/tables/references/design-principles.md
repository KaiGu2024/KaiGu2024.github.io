# Table design principles — the rationale

The [SKILL.md](../SKILL.md) checklist is the operating summary. This file is the *why*: the perceptual and editorial reasoning behind each rule, with the standard sources so a choice can be defended in a referee reply.

The governing frame (Schwabish 2020; CSE Best Practices) is that every design decision serves one of two jobs — **aiding comparison** (let the reader put two numbers side by side) or **reducing the cost of reading** (let them find one exact number fast). A table is not a picture; it does not give a gestalt impression the way a chart does. It is a reference object. If a rule helps neither comparison nor lookup, drop it.

This is the table-side counterpart to the perceptual ranking in [../../visualization/SKILL.md](../../visualization/SKILL.md). Figures encode magnitude in position and length; tables display the magnitude itself. The brand rules (palette, fonts) do **not** apply to a typeset table — a published table is black type on white, set in the document's body font. Keep aesthetics out; keep legibility in.

---

## 1. Variable naming & labels

**Rule — label, don't symbolize.** Use a self-explanatory word label for every regressor (`Ad spending`, `Months since launch`), not the coding name (`ADSPND`, `MSL`) and not the model symbol (`β₁`, `X₃`). Cryptic names force the reader to page back to the model section to decode each row — the single most common readability failure in empirical tables (Keith Head).

**Preserve notation without sacrificing readability.** When the paper's argument hangs on a symbol, put the symbol in parentheses *below* the word label:

```
Ad spending
  (S_t)
```

The reader scanning the table sees words; the reader cross-checking the model finds the symbol. You lose nothing.

**You have the room.** A regression table is typically 4–8 columns of specifications against a stub column of regressors. The stub is the one wide column — spend the width on legible labels.

**Sentence case, not Title Case.** `Ad spending`, not `Ad Spending` and never `AD SPENDING`. Sentence case reads at prose speed; Title Case and caps slow the eye and waste vertical rhythm (Schwabish; CSE).

**Relabel in the paper layer, not the code.** Variable names serve different masters: the script wants `emp_stat`, the paper wants `Employment`. Do the rename at export time (`covariate.labels` in stargazer, `coef_map` in modelsummary, label/varlabels in estout) so the analysis code stays untouched. **Never guess what an abbreviation expands to** — if the source name is ambiguous, ask the user. A wrong label is worse than a cryptic one.

---

## 2. Layering & ordering — rows and columns

**Comparisons go down columns, not across rows.** This is the load-bearing rule of table layout (Schwabish; Ehrenberg). The eye compares a vertical stack of numbers far more accurately than a horizontal run, because aligned digits line up place-by-place. So: **arrange the table so the contrast you want the reader to make runs down a column.** If the story is "the coefficient is stable across specifications," the coefficient should appear once per column with the columns side by side — the reader's eye travels along one row to see stability, but reads each number down its column.

**Columns are alternative specifications.** The standard economics/marketing layout: stub = regressors, each column = one model (adds a control, changes the sample, swaps the estimator). 4–8 columns is the comfortable range; beyond that, split into two tables or a panel.

**Time runs across columns.** For descriptive or time-series tables, let years/periods span the columns left-to-right — that is the direction readers expect time to flow, and it keeps each *variable* in a single readable row.

**Derived values sit to the right of their inputs.** A ratio, a difference, a percentage-change column belongs immediately right of the columns it is computed from, so the reader can verify the arithmetic without hunting.

**Group related rows; demote the rest.** Cluster regressors that belong together (all the price terms, all the fixed-effects indicators) and separate the groups with a trimmed `\cmidrule(lr){2-4}` or an indented sub-stub — **not** a horizontal line through the whole table and never a vertical rule. When control variables crowd out the headline coefficients, move them to a labeled panel ("Controls: Yes") or an auxiliary table. The reader came for the treatment effect; don't bury it under twelve controls.

**Order rows by meaning, then magnitude.** Put the variable of interest first (or in a clearly flagged block), not wherever the regression printout happened to list it. Within a group of comparable rows, ordering by size aids comparison — but never reorder if a conventional order carries meaning (e.g. a dose ladder, a time sequence).

**Standard errors live with their coefficient.** Put the SE in parentheses directly below its coefficient, in the same column. This keeps the estimate-and-uncertainty pair as one visual unit and is the near-universal convention. Report SEs, not t-stats or bare p-values (Keith Head) — the SE lets the reader compute any test they want.

**Give the reader a denominator.** Report a baseline against which the coefficient can be sized — the mean of the dependent variable (overall, or by group), or the control-group level — usually as a row block at the foot of the table. A coefficient is signed but not *sized* on its own: `0.056` means little until the reader knows the outcome averages `0.077`, at which point it reads as a ~70% shift. Don't make them hunt the prose for the denominator; put it under the estimates. This is the table-side counterpart of "plot differences, not raw" in [../../visualization/SKILL.md](../../visualization/SKILL.md) and the Benchmark step in [../../report.md](../../report.md). *(Learned from a real specimen: a citation-concentration table whose foot reported mean HHI for each platform, so the headline coefficient could be read as a relative effect, not a bare number.)*

**Let the column order carry the argument.** When the specification columns form a natural sequence — looser to stricter sample, shorter to longer horizon, fewer to more controls — order them along it so the reader reads the result as a gradient. A coefficient that climbs monotonically across an ordered column run (e.g. `~0` at the loosest sample to `0.056` at the strictest) is a dose-response finding the layout makes visible *for free*; a scrambled column order throws that signal away. Sequence the columns deliberately — don't inherit the printout's order.

**If the comparison must run across a row, emphasize — don't restructure.** The down-a-column rule has a legitimate exception: a single coefficient of interest, read across columns that are themselves the comparison (alternative samples, subgroups, horizons). You can't move that comparison into a column. Compensate by anchoring the eye — **bold** the significant coefficients, or lightly shade the column that carries the headline — so the reader lands on the result even while scanning horizontally.

---

## 3. Significant figures & precision

**Two effective digits (Ehrenberg's rule).** Numbers in a table should generally carry **two significant figures of the part that varies** — that is what the eye can actually compare. `3.4` and `3.7` compare instantly; `3.41827` and `3.69134` do not, and the extra digits are almost never meaningful. Coefficients should rarely show more than 2–3 places either side of the decimal (Keith Head).

**Choose units to land in that range.** If a coefficient comes out as `0.000032`, rescale the regressor (per \$1,000 instead of per \$1) so it reads `0.32`. If it comes out `75432.8`, report the outcome in thousands. The goal is numbers a reader can hold in their head and compare — pick units that put the interesting digits next to the decimal point. (Exception: unit-free elasticities from log-log models are already well-scaled.)

**Constant decimals down a column.** Every entry in a column shows the *same* number of decimal places — `1.20`, not `1.2`, when the column elsewhere shows `1.23`. Consistent decimals are what make a numeric column align and scan as a block; ragged decimals break the vertical read.

**Significance ≠ display precision.** Two-significant-*figure* display is about communication, not about the underlying estimate's precision. Never confuse "round the displayed value to 2 figures" with "the estimate is only good to 2 figures." And never re-round below what the source reported without the user asking (Non-negotiable rule 1).

---

## 4. Alignment & decluttering

**Right-align (or decimal-align) numbers.** Numbers are compared right-to-left — ones, then tens, then hundreds — so right alignment puts the digits that matter in register. When a column mixes decimal counts (it shouldn't, per §3, but in mixed-unit descriptive tables it happens), decimal-align instead. Left-align or center only when entries have genuinely different units and there is nothing to compare.

**Left-align text; match the header to its column.** Stub labels and text cells left-align. A column header takes the alignment of the column it sits over — a header above a right-aligned number column right-aligns too.

**booktabs rules only — and few of them.** Use `\toprule`, `\midrule`, `\bottomrule`; nothing else by default. booktabs sets these thicker top/bottom, thinner in the middle, with breathing room around each so superscripts don't collide with the rule above. Add an interior rule only where it does structural work: under the column-number row, under a spanner head (`\cmidrule(lr)`), above a totals row.

**No vertical rules. Ever.** This is not a preference — vertical lines in tables are essentially forbidden in professional typesetting (Chicago Manual; booktabs manual). Column separation is the job of white space, not ink. If columns feel too close, add space (`\addlinespace`, wider column specs), don't add a line.

**White space over shading and boxes.** Don't shade, box, or color cells to create structure; let alignment and spacing do it. The one defensible use of shading is light zebra-striping in a very wide table to help the eye track a row across — and even then, say so in the notes. Never use reversed type (white on dark).

**Title above, neutral, unique.** The caption sits above the table, states what the table shows without editorializing the finding ("Effect of advertising on sales," not "Advertising strongly boosts sales"), and is unique enough to cite. Notes go below as a **typed, bottom-anchored block**, in reading order: scope/source → cross-references → abbreviation definitions → SE/clustering key → significance legend. The last two are anchors — the parenthetical SE/clustering key is second-to-last and the star legend is dead last — because the stars are computed from those SEs, so the reader must learn what the parentheses hold before the stars mean anything. The practical consequence (the one people get wrong): a note added later is inserted *by type* above those anchors, not appended after the legend. See the SKILL.md "Notes block" section.

---

## Sources

- Jonathan A. Schwabish, "Ten Guidelines for Better Tables," *Journal of Benefit-Cost Analysis* 11(2), 2020 — the modern synthesis; right-align numbers, left-align text, declutter rules, comparisons-down-columns. <https://www.cambridge.org/core/journals/journal-of-benefit-cost-analysis/article/abs/ten-guidelines-for-better-tables/74C6FD9FEB12038A52A95B9FBCA05A12>
- Keith Head, "Regression Tables" (research advice) — economics-specific: readable labels with symbol below, sensible units, SEs not t-stats, 4–8 specification columns. <https://blogs.ubc.ca/khead/research/research-advice/regression-tables>
- Andrew S. C. Ehrenberg, *A Primer in Data Reduction* / "Rudiments of Numeracy" — the two-effective-digits rule and rounding for comparison.
- Andrew Gelman, "Why Tables Are Really Much Better Than Graphs" (rejoinder), *JCGS* 20(1), 2011 — (satirical) catalogue of what makes tables hard to read. <https://sites.stat.columbia.edu/gelman/research/published/tables5.pdf>
- "Best Practices in Table Design," *Science Editor* (CSE) — the aiding-comparisons / reducing-clutter / increasing-readability framing; line and shading rules. <https://www.csescienceeditor.org/article/best-practices-in-table-design/>
- Simon Fear, *Publication quality tables in LaTeX* (booktabs manual), CTAN — rule weights, spacing, "never use vertical rules," `\cmidrule(lr)`. <https://tug.ctan.org/macros/latex/contrib/booktabs/booktabs.pdf>
