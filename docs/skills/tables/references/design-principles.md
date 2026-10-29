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

**Name the substantive outcome in the header.** A heading should tell readers what is measured. `ChatGPT sessions` identifies what is counted; `Recorded sessions` describes measurement while leaving the platform unclear. Put the fuller qualification, such as `recorded ChatGPT conversation sessions`, in the notes when supported by the source. Keep units and distinctions needed to interpret the numbers in the header; do not shorten away the outcome's identity.

**Budget label width alongside numeric width.** Give the stub enough room for legible labels while reserving space for complete estimates and intervals. Wrap long labels where necessary; the number of columns alone does not establish that the table will fit (see §4).

**Sentence case, not Title Case.** `Ad spending`, not `Ad Spending` and never `AD SPENDING`. Sentence case reads at prose speed; Title Case and caps slow the eye and waste vertical rhythm (Schwabish; CSE).

**Relabel in the paper layer, not the code.** Variable names serve different masters: the script wants `emp_stat`, the paper wants `Employment`. Do the rename at export time (`covariate.labels` in stargazer, `coef_map` in modelsummary, label/varlabels in estout) so the analysis code stays untouched. **Never guess what an abbreviation expands to** — if the source name is ambiguous, ask the user. A wrong label is worse than a cryptic one.

---

## 2. Layering & ordering — rows and columns

**Design around the comparison readers need to make.** Start with the outcomes, groups, or specifications readers need to compare. Comparing down aligned numeric columns is a useful preference, not a rigid rule. Choose the orientation that keeps the relevant values easy to compare with the least repeated labeling and scanning.

**Use grouped columns when outcomes and statistics are shared.** For example, if two groups report the same outcomes with an estimate and interval for each, list each outcome once and give each group a column block with matching statistic headers. This places the group comparison side by side and eliminates repeated outcome rows. Use stacked panels with consistent row order and statistic columns when the grouped layout would be too wide at a readable font size.

**Columns can be alternative specifications.** The standard economics/marketing layout uses a regressor stub and one model per column (adds a control, changes the sample, swaps the estimator). Use it when comparing specifications is the task. Judge how many columns fit by their actual content and the intended display width; split into tables or stacked panels when needed.

**Time runs across columns.** For descriptive or time-series tables, let years/periods span the columns left-to-right — that is the direction readers expect time to flow, and it keeps each *variable* in a single readable row.

**Derived values sit to the right of their inputs.** A ratio, a difference, a percentage-change column belongs immediately right of the columns it is computed from, so the reader can verify the arithmetic without hunting.

**Group related rows; demote the rest.** Cluster regressors that belong together (all the price terms, all the fixed-effects indicators) and separate the groups with a trimmed `\cmidrule(lr){2-4}` or an indented sub-stub — **not** a horizontal line through the whole table and never a vertical rule. When control variables crowd out the headline coefficients, move them to a labeled panel ("Controls: Yes") or an auxiliary table. The reader came for the treatment effect; don't bury it under twelve controls.

**Order rows by meaning, then magnitude.** Put the variable of interest first (or in a clearly flagged block), not wherever the regression printout happened to list it. Within a group of comparable rows, ordering by size aids comparison — but never reorder if a conventional order carries meaning (e.g. a dose ladder, a time sequence).

**Standard errors live with their coefficient.** Put the SE in parentheses directly below its coefficient, in the same column. This keeps the estimate-and-uncertainty pair as one visual unit and is the near-universal convention. Report SEs, not t-stats or bare p-values (Keith Head) — the SE lets the reader compute any test they want.

**Give the reader a denominator.** Report a baseline against which the coefficient can be sized — the mean of the dependent variable (overall, or by group), or the control-group level — usually as a row block at the foot of the table. A coefficient is signed but not *sized* on its own: `0.056` means little until the reader knows the outcome averages `0.077`, at which point it reads as a ~70% shift. Don't make them hunt the prose for the denominator; put it under the estimates. This is the table-side counterpart of "plot differences, not raw" in [../../visualization/SKILL.md](../../visualization/SKILL.md) and the Benchmark step in [report](../../report/SKILL.md). *(Learned from a real specimen: a citation-concentration table whose foot reported mean HHI for each platform, so the headline coefficient could be read as a relative effect, not a bare number.)*

**Let the column order carry the argument.** When the specification columns form a natural sequence — looser to stricter sample, shorter to longer horizon, fewer to more controls — order them along it so the reader reads the result as a gradient. A coefficient that climbs monotonically across an ordered column run (e.g. `~0` at the loosest sample to `0.056` at the strictest) is a dose-response finding the layout makes visible *for free*; a scrambled column order throws that signal away. Sequence the columns deliberately — don't inherit the printout's order.

**Horizontal comparisons need clear structure.** When a coefficient is compared across samples, subgroups, or horizons, consistent statistic order, informative spanner headings, and deliberate spacing help readers track it. Choose the layout on those grounds; horizontal comparison alone does not call for bolding significant coefficients or shading cells.

---

## 3. Significant figures & precision

**Two effective digits (Ehrenberg's rule).** Numbers in a table should generally carry **two significant figures of the part that varies** — that is what the eye can actually compare. `3.4` and `3.7` compare instantly; `3.41827` and `3.69134` do not, and the extra digits are almost never meaningful. Coefficients should rarely show more than 2–3 places either side of the decimal (Keith Head).

**Choose units to land in that range.** If a coefficient comes out as `0.000032`, rescale the regressor (per \$1,000 instead of per \$1) so it reads `0.32`. If it comes out `75432.8`, report the outcome in thousands. The goal is numbers a reader can hold in their head and compare — pick units that put the interesting digits next to the decimal point. (Exception: unit-free elasticities from log-log models are already well-scaled.)

**Constant decimals down a column.** Every entry in a column shows the *same* number of decimal places — `1.20`, not `1.2`, when the column elsewhere shows `1.23`. Consistent decimals are what make a numeric column align and scan as a block; ragged decimals break the vertical read.

**Significance ≠ display precision.** Two-significant-*figure* display is about communication, not about the underlying estimate's precision. Never confuse "round the displayed value to 2 figures" with "the estimate is only good to 2 figures." And never re-round below what the source reported without the user asking (Non-negotiable rule 1).

---

## 4. Alignment & decluttering

**Allocate width before wrapping numbers or shrinking type.** Size numeric columns for their longest complete entry, including signs, significance markers, and interval endpoints. First shorten or wrap row labels and headers while preserving meaning, then adjust cell padding or intercolumn spacing. Keep each estimate and each interval intact; placing an SE or interval below its estimate is a deliberate layout choice, not a reason to split the number or interval itself. If the table still exceeds the available width, revisit orientation or use stacked panels. Preserve readable font sizes and inspect the result at its intended placement size rather than relying on automatic scaling to fit.

**Right-align (or decimal-align) numbers.** Numbers are compared right-to-left — ones, then tens, then hundreds — so right alignment puts the digits that matter in register. When a column mixes decimal counts (it shouldn't, per §3, but in mixed-unit descriptive tables it happens), decimal-align instead. Left-align or center only when entries have genuinely different units and there is nothing to compare.

**Left-align text; match the header to its column.** Stub labels and text cells left-align. A column header takes the alignment of the column it sits over — a header above a right-aligned number column right-aligns too.

**Vertically center peer column headings.** When single-line and multiline headings share a header row, center them vertically within that row while preserving their horizontal alignment. This keeps headings at the same level visually aligned despite different line counts. Keep higher-level group headings in a separate row so the hierarchy remains clear. Check the rendered result after wrapping headers or changing column widths.

**booktabs rules only — and few of them.** Use `\toprule`, `\midrule`, `\bottomrule`; nothing else by default. booktabs sets these thicker top/bottom, thinner in the middle, with breathing room around each so superscripts don't collide with the rule above. Add an interior rule only where it does structural work: under the column-number row, under a spanner head (`\cmidrule(lr)`), above a totals row.

**No vertical rules. Ever.** This is not a preference — vertical lines in tables are essentially forbidden in professional typesetting (Chicago Manual; booktabs manual). Column separation is the job of white space, not ink. If columns feel too close, add space (`\addlinespace`, wider column specs), don't add a line.

**White space over shading and boxes.** Don't shade, box, or color cells to create structure; let alignment and spacing do it. The one defensible use of shading is light zebra-striping in a very wide table to help the eye track a row across — and even then, say so in the notes. Never use reversed type (white on dark).

**Title above, neutral, unique.** The caption sits above the table, states what the table shows without editorializing the finding ("Effect of advertising on sales," not "Advertising strongly boosts sales"), and is unique enough to cite. Notes go below as **one continuous paragraph**, with one *Notes:* label, in reading order: scope → specification → definitions → provenance and cross-references → parenthetical SE/clustering key → significance legend. Include only applicable content. The inference key and legend remain inline at the end so readers learn what the parentheses hold before interpreting the stars. Allow automatic line wrapping to the table width; do not split note types into separate paragraphs, items, or forced lines. Insert later additions by type within the same paragraph, before the applicable inference key and legend. See the SKILL.md "Notes block" section.

---

## Sources

- Jonathan A. Schwabish, "Ten Guidelines for Better Tables," *Journal of Benefit-Cost Analysis* 11(2), 2020 — the modern synthesis; right-align numbers, left-align text, declutter rules, comparisons-down-columns. <https://www.cambridge.org/core/journals/journal-of-benefit-cost-analysis/article/abs/ten-guidelines-for-better-tables/74C6FD9FEB12038A52A95B9FBCA05A12>
- Keith Head, "Regression Tables" (research advice) — economics-specific: readable labels with symbol below, sensible units, SEs not t-stats, 4–8 specification columns. <https://blogs.ubc.ca/khead/research/research-advice/regression-tables>
- Andrew S. C. Ehrenberg, *A Primer in Data Reduction* / "Rudiments of Numeracy" — the two-effective-digits rule and rounding for comparison.
- Andrew Gelman, "Why Tables Are Really Much Better Than Graphs" (rejoinder), *JCGS* 20(1), 2011 — (satirical) catalogue of what makes tables hard to read. <https://sites.stat.columbia.edu/gelman/research/published/tables5.pdf>
- "Best Practices in Table Design," *Science Editor* (CSE) — the aiding-comparisons / reducing-clutter / increasing-readability framing; line and shading rules. <https://www.csescienceeditor.org/article/best-practices-in-table-design/>
- Simon Fear, *Publication quality tables in LaTeX* (booktabs manual), CTAN — rule weights, spacing, "never use vertical rules," `\cmidrule(lr)`. <https://tug.ctan.org/macros/latex/contrib/booktabs/booktabs.pdf>
