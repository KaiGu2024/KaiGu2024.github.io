# Annotations and axis text

Use this reference when a figure contains direct labels, event annotations, dense tick labels, or axis wording that needs wrapping. The blocking acceptance gate remains in `../SKILL.md` rule 13; code patterns live in `recipes.md`.

## Contents

1. [Direct-label coverage](#direct-label-coverage)
2. [Orientation and contrast](#orientation-and-contrast)
3. [Annotation styling](#annotation-styling)
4. [Axis titles and tick labels](#axis-titles-and-tick-labels)
5. [Event-study axes](#event-study-axes)
6. [Unit disclosure across the figure and TeX](#unit-disclosure-across-the-figure-and-tex)
7. [Collision and clipping](#collision-and-clipping)

## Direct-label coverage

Prefer direct labels for the subjects and groups the reader needs to identify. For a few equal-weight series, label each one. For a focal subject against many background subjects, label the focal subject and necessary comparators individually; identify the rest collectively, such as "Other languages", in available white space or the caption. Use a compact key if group membership cannot be explained unambiguously with direct labels.

Do not double-label horizontal bars when their y-axis ticks already name them. If all required series cannot be labeled after using `ggrepel` and an annotation gutter, facet or change the encoding instead of shrinking text.

For scatterplots and other point-based figures, select labels for focal subjects, substantive benchmarks or milestones, and unusually positioned observations whose identity helps explain the pattern. Outliers need not all be named. Apply the criterion consistently, including relevant counterexamples, and preserve all observations regardless of label selection. Record selected IDs and the reason in the plotting code or shared specification; describe the rule in publication prose only when it affects interpretation.

Decide label selection before collision repair. Do not let `ggrepel` choose which subjects matter: use `max.overlaps = Inf` for the selected labels and inspect the result. If they still crowd, remove optional labels by the stated relevance criterion; facet or change layout when required labels cannot fit. Keep leader segments when needed to match a label unambiguously to its point. Never omit an inconvenient observation or required comparator to obtain a cleaner story.

Keep labels in white space rather than on data marks. Use `nudge_x`, `nudge_y`, or `ggrepel`; reserve `geom_label()` for the rare case where no white space exists.

## Orientation and contrast

Use horizontal annotation prose whenever possible. When a vertical event line or narrow axis forces rotation, use `angle = 90` only: the text reads bottom-to-top, with the reader's head tilting left. Never use `angle = -90` or `270`. Avoid diagonal prose between 15° and 75°.

Short standardized tick labels are different from prose. Dates such as `2024-12` and category strings up to about eight characters can use `angle = 30, hjust = 1` when denser breaks are valuable. For long arbitrary categories, prefer `coord_flip()` over rotation.

Use `grey30` or darker on white for substantive annotations, or a sufficiently dark focal color. Light gray is for context marks, not text the reader must decipher.

## Annotation styling

Use **16–18 pt** for direct line and point labels; start at 16 pt to match tick labels. Use `size = 16 / ggplot2::.pt` in `geom_text()` or `geom_text_repel()`, and set `family = "Newsreader"` explicitly: theme text settings do not set the font family of text geoms. `geom_text()` also supports `size = 16, size.unit = "pt"`; see the [ggplot2 text-unit documentation](https://ggplot2.tidyverse.org/articles/ggplot2-specs.html). Keep Lora for the 20 pt axis titles and 18 pt facet strips.

Write concise names or plain nouns, usually one to three words: `ChatGPT`, `Google`, `Treatment`, `Germany`. Preserve the full observation identifier when needed for unambiguous identification. Country names are required when identifying country-level outliers; omit country details only when they are extra context for another identifier. Do not append parentheses, qualifiers, units, sample sizes, periods, or model specifications. Put units in axis titles and contextual details in the TeX caption.

For ordinary endpoint labels, use `geom_text_repel(direction = "y")`. When endpoints converge in a narrow vertical band, keep one label rail: rotate labels to `angle = 90, hjust = 0`, anchor each at its endpoint, and repel with `direction = "x"`. If that rail still cannot fit, facet or switch to layer-and-highlight.

## Axis titles and tick labels

Treat axis titles and ticks as the figure's structural text. Follow these rules:

- Use sentence case.
- Spell out the quantity; avoid cryptic abbreviations.
- Name what is actually plotted: a level, mean, share, difference, or estimated effect. Include aggregation or the denominator when it distinguishes quantities: `Mean distinct foundation models per language`, not `Distinct foundation models`. Avoid bare `Value`, `Outcome`, or `Coefficient`.
- Put the unit in parentheses at the end: `Referral share (%)`, `Response time (ms)`.
- Aim for roughly three to six words; this is a brevity target, not a limit that justifies dropping the outcome or unit. Use `labs_pub()` to wrap at 32 characters for x titles and 26 for y titles by default. Prefer at most two lines when possible.
- Use `y = NULL` only when y-axis ticks already name every item, as in sorted horizontal bars.
- Format ticks with `scales::label_*`; avoid raw long numbers and scientific notation. Aim for about six characters per tick label. Keep dates in ISO `%Y-%m`.

When a title is too long, shorten or wrap it before increasing margins. Do not replace a precise axis title with an in-figure title or subtitle.

## Event-study axes

For DiD, dynamic treatment-effect, or regression event studies, use the outcome name and the plotted coefficient scale. Derive wording from the estimation code and plotted transformations; a short DV-only title is allowed, with the caption or note identifying the estimates and reference period.

- **X: time unit + event.** Use `Months relative to policy adoption`, `Years relative to first treatment`, or `Days relative to announcement`. Avoid generic `Time` or `Periods` when the unit is known. Define zero in the figure note (for example, first treated month); distinguish announcement from implementation. Use integer event-time ticks, including zero and the reference period where applicable. Label pooled tails explicitly, such as `≤ −12` and `≥ 12`.
- **Y: `Effect on [DV]` or the DV itself, plus scale.** Use `Effect on employment (percentage points)` or `Employment (percentage points)`; likewise `Effect on earnings (log points)` or `Earnings (log points)`, and `Effect on test scores (SD)` or `Test scores (SD)`. Use the DV-only form when a causal interpretation is not supported or a shorter title is preferred. Do not prefix event-study y-axis titles with `Differences in`, `Difference in`, or `Estimated difference in`. `Estimated effect` alone leaves the outcome and scale unidentified. Explain the estimated contrast and reference period concisely in the caption or note; a DV-only title does not mean the plotted coefficients are outcome levels. Pre-treatment coefficients are diagnostics; describe their interpretation in the note where needed rather than calling them pre-treatment causal effects.
- **Match the numerical transformation.** A coefficient for a 0–1 outcome becomes percentage points only after multiplying the estimate and interval endpoints by 100. Raw coefficients for a natural-log outcome are log points; do not simply relabel them `%`. If reporting `100 × (exp(coef) − 1)`, transform the interval endpoints too and explain the transformation and its model-specific interpretation. For SD units, state the standardization population in the note.
- **Keep normalization in the note.** Name the reference period or base-period scheme, comparison group, estimator, interval level and whether intervals are pointwise or simultaneous, and clustering where used. Do not assume every estimator omits period −1: some use varying pre-treatment base periods. A zero added only for normalization has no estimated confidence interval; identify it as the reference. See [Callaway on universal versus varying base periods](https://bcallaway11.github.io/posts/event-study-universal-v-varying-base-period).
- **Show the relevant zero.** Include a horizontal zero-effect reference and the full confidence intervals; signed effects are an exception to the zero-lower-bound rule. An event line at 0 marks event time; a line at −0.5 separates the last untreated and first treated discrete periods when 0 is the first treated period. Choose and explain the convention consistently.

Across outcome panels, keep the x title and time convention consistent, but give each y title its own outcome and scale. Put model specifications and sample restrictions needed to interpret the display in the caption or note. Keep fuller identification arguments in methods, retaining a local qualification when its omission would mislead.

## Unit disclosure across the figure and TeX

Use three complementary layers:

1. **Axis label:** state the metric and aggregation, such as `Median parameters per foundation model`.
2. **LaTeX caption or panel subtitle:** identify the population or analytical object, such as `Foundations adopted for low-market languages`. For a single-panel figure, the caption performs this role.
3. **Figure note:** state what one observation represents, the universe, denominator, sample size or missing-data coverage, and exclusions, such as `Unit: one registry-recognized foundation model; 25 of 27 adopted foundations have measured parameter counts.`

Make the layers complement rather than repeat one another. Before acceptance, compare them with the code's aggregation and the surrounding prose; all must describe the same unit, population, and denominator.

Apply the shared [concise-note guidance](../../tables/SKILL.md#concise-notes-without-defensive-prose): include what makes this display interpretable on its own, and qualify only where interpretation, credibility, or use changes. Keep internal checks and unresolved author questions outside the publication prose; avoid generic disclaimers and repeated caveats.

**Disclose inference units separately.** The observation or plotted aggregation unit does not establish the clustering level. For uncertainty notes, follow the shared [inference-wording guidance](../../tables/SKILL.md#inference-wording-for-tables-and-figures): identify interval coverage, method, and actual clustering dimensions from the source. "Firm influence scores" does not replace "standard errors clustered at the firm level"; include score construction only when needed and verified.

## Collision and clipping

Apply repairs in the order specified by the acceptance gate:

1. Shorten or wrap text.
2. Thin breaks, use `guide_axis(n.dodge = 2)`, or flip long categorical axes.
3. Create a data-scale annotation gutter with `expand`.
4. Use `ggrepel`.
5. Select a `theme_pub(gutter = ...)` profile or increase the relevant device dimension.
6. Change the layout or encoding.

Right-side direct labels require both scale expansion and `theme_pub(gutter = "right")`. Off-panel annotations require `coord_cartesian(clip = "off")`, matching scale expansion, and the relevant margin profile. Wrap long category labels with `scales::label_wrap()` or `stringr::str_wrap()` before enlarging the left gutter.

Keep the default sizes in `../SKILL.md` rule 6 during collision repairs. If the venue or user requires different sizes, check them at final placement. Open and inspect the saved artifact at placement size after every repair.
