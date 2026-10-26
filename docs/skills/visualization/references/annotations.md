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

Do not double-label horizontal bars when their y-axis ticks already name them. If all required series cannot be labeled at a readable size after the [collision repairs](#collision-and-clipping), facet or change the encoding.

For scatterplots and other point-based figures, select labels for focal subjects, substantive benchmarks or milestones, and unusually positioned observations whose identity helps explain the pattern. Outliers need not all be named. Apply the criterion consistently, including relevant counterexamples, and preserve all observations regardless of label selection. Record selected IDs and the reason in the plotting code or shared specification; describe the rule in publication prose only when it affects interpretation.

Decide label selection before collision repair. Do not let `ggrepel` choose which subjects matter: use `max.overlaps = Inf` for the selected labels and inspect the result. If they still crowd, remove optional labels by the stated relevance criterion; facet or change layout when required labels cannot fit. Keep leader segments when needed to match a label unambiguously to its point. Never omit an inconvenient observation or required comparator to obtain a cleaner story.

Keep labels in white space rather than on data marks. Use `nudge_x`, `nudge_y`, or `ggrepel`; reserve `geom_label()` for the rare case where no white space exists.

## Orientation and contrast

Use horizontal annotation prose whenever possible. When a vertical event line or narrow axis forces rotation, use `angle = 90` only: the text reads bottom-to-top, with the reader's head tilting left. Never use `angle = -90` or `270`. Avoid diagonal prose between 15° and 75°.

Short standardized tick labels are different from prose. Dates such as `2024-12` and category strings up to about eight characters can use `angle = 30, hjust = 1` when denser breaks are valuable. For long arbitrary categories, prefer `coord_flip()` over rotation.

Use `grey30` or darker on white for substantive annotations, or a sufficiently dark focal color. Light gray is for context marks, not text the reader must decipher.

## Annotation styling

Match direct-label sizes to the tick text chosen for the placement under [rule 6](../SKILL.md#1-standards). The [shared setup](../SKILL.md#4-setup) defines `label_pt`; use `size = label_pt / ggplot2::.pt` and `family = "Newsreader"` in `geom_text()` or `geom_text_repel()`. Theme settings do not set text-geom sizes or families. Lora remains the title and facet-strip family.

Write concise names or plain nouns, usually one to three words: `ChatGPT`, `Google`, `Treatment`, `Germany`. Preserve the full observation identifier when needed for unambiguous identification. Country names are required when identifying country-level outliers; omit country details only when they are extra context for another identifier. Do not append parentheses, qualifiers, units, sample sizes, periods, or model specifications. Allocate units and context using the [three disclosure layers](#unit-disclosure-across-the-figure-and-tex).

For ordinary endpoint labels, use `geom_text_repel(direction = "y")`. When endpoints converge in a narrow vertical band, keep one label rail: rotate labels to `angle = 90, hjust = 0`, anchor each at its endpoint, and repel with `direction = "x"`. If that rail still cannot fit, facet or switch to layer-and-highlight.

## Axis titles and tick labels

Treat axis titles and ticks as the figure's structural text. Follow these rules:

- Use sentence case.
- Name the quantity in familiar language rather than copying a variable name; avoid cryptic abbreviations. Preserve distinctions such as visits versus users or counts versus shares.
- Identify the metric and include aggregation or the denominator when it distinguishes quantities: `Mean distinct foundation models per language`, not `Distinct foundation models`. For event-study estimates, use the outcome-name convention below. Avoid bare `Value`, `Outcome`, or `Coefficient`.
- For descriptive charts, put the unit in parentheses at the end: `Referral share (%)`, `Response time (ms)`. Event-study y titles use the outcome alone, with units and scale in the caption or note.
- Use the shortest clear title; one or two words may suffice. Use `labs_pub()` to wrap at 32 characters for x titles and 26 for y titles by default. Prefer at most two lines when possible.
- Use `y = NULL` only when y-axis ticks already name every item, as in sorted horizontal bars.
- **Keep each categorical tick label on one line by default**, especially on the y-axis of horizontal bars or dot plots. Choose readable typography for the placement, shorten names only when identity and meaning remain unambiguous, and allocate horizontal label space without squeezing the data. Use a wider or horizontal layout when needed. Preserve full names when shortening would confuse categories; do not truncate, omit, or make required labels unreadably small. Wrap only as a last resort under fixed placement constraints, then recheck readability and row spacing.
- Format numeric ticks with `scales::label_*`; avoid raw long numbers and scientific notation. Aim for about six characters per numeric tick label. Keep dates in ISO `%Y-%m`.

When a title is too long, shorten or wrap it before increasing margins. Do not replace a precise axis title with an in-figure title or subtitle.

## Event-study axes

For DiD, dynamic treatment-effect, or regression event studies, default to a short, plain-language outcome name. Derive the name and scale from the estimation code and plotted transformations; identify the estimates, scale, comparison, and reference period in the caption or note.

- **X: time unit + event.** Use `Months relative to policy adoption`, `Years relative to first treatment`, or `Days relative to announcement`. Avoid generic `Time` or `Periods` when the unit is known. Define zero in the figure note (for example, first treated month); distinguish announcement from implementation. Use integer event-time ticks, including zero and the reference period where applicable. Label pooled tails explicitly, such as `≤ −12` and `≥ 12`.
- **Y: outcome name alone.** Prefer `Search visits`, `Employment`, `Earnings`, or `Test scores`. Put units and scales such as percentage points, log points, or SD in the caption or note rather than appending them to the title. Omit routine prefixes such as `Weekly effect on`, `Estimated effect on`, and `Effect on`; use `Effect on [DV]` only when explicitly requested or needed to clarify the display and supported by the design. Do not use `Differences in`, `Difference in`, or `Estimated difference in`. A familiar outcome name is preferable to a technical DV label, provided it names the same measure.
- **Put routine timing and aggregation in the caption or note.** For example, `Weekly effect on search visits` becomes `Search visits`, with the note defining visits per user per week. Event-time ticks describe timing relative to the event; they do not by themselves define the outcome's aggregation window. Retain a qualifier on the axis when it distinguishes measures, such as `Cumulative search visits` versus `Search visits`, or daily versus weekly outcomes shown together. Explain that the plotted values are coefficients, including pre-event diagnostics, in the caption or note.
- **Match the numerical transformation.** A coefficient for a 0–1 outcome becomes percentage points only after multiplying the estimate and interval endpoints by 100. Raw coefficients for a natural-log outcome are log points; do not simply relabel them `%`. If reporting `100 × (exp(coef) − 1)`, transform the interval endpoints too and explain the transformation and its model-specific interpretation. For SD units, state the standardization population in the note.
- **Keep normalization in the note.** Name the reference period or base-period scheme, comparison group, estimator, interval level and whether intervals are pointwise or simultaneous, and clustering where used. Do not assume every estimator omits period −1: some use varying pre-treatment base periods. A zero added only for normalization has no estimated confidence interval; identify it as the reference. See [Callaway on universal versus varying base periods](https://bcallaway11.github.io/posts/event-study-universal-v-varying-base-period).
- **Show the relevant zero.** Include a horizontal zero-effect reference and the full confidence intervals; extend the value axis below zero whenever estimates or interval endpoints are negative. Choose limits with modest headroom around the plotted range, following [rule 3](../SKILL.md#1-standards). An event line at 0 marks event time; a line at −0.5 separates the last untreated and first treated discrete periods when 0 is the first treated period. Choose and explain the convention consistently.

Across outcome panels, keep the x title and time convention consistent, name each outcome on its y axis, and identify each panel's scale in the caption or note. Put model specifications and sample restrictions needed to interpret the display there too. Keep fuller identification arguments in methods, retaining a local qualification when its omission would mislead.

## Unit disclosure across the figure and TeX

Use three complementary layers:

1. **Axis label:** identify the metric; for event studies, use the outcome name alone. Other charts can include units and distinguishing aggregation, such as `Median parameters per foundation model`.
2. **LaTeX caption or panel subtitle:** identify the population or analytical object, such as `Foundations adopted for low-market languages`. For a single-panel figure, the caption performs this role.
3. **Figure note:** supply units, scales, and aggregation omitted from the axis or caption, such as `Employment coefficients are in percentage points.` State what one observation represents, the universe, denominator, sample size or missing-data coverage, and exclusions where relevant.

Make the layers complement rather than repeat one another. Before acceptance, compare them with the code's aggregation and the surrounding prose; all must describe the same unit, population, and denominator.

Apply the shared [concise-note guidance](../../tables/SKILL.md#concise-notes-without-defensive-prose): include what makes this display interpretable on its own, and qualify only where interpretation, credibility, or use changes. Keep internal checks and unresolved author questions outside the publication prose; avoid generic disclaimers and repeated caveats.

**Disclose inference units separately.** The observation or plotted aggregation unit does not establish the clustering level. For uncertainty notes, follow the shared [inference-wording guidance](../../tables/SKILL.md#inference-wording-for-tables-and-figures): identify interval coverage, method, and actual clustering dimensions from the source. "Firm influence scores" does not replace "standard errors clustered at the firm level"; include score construction only when needed and verified.

## Collision and clipping

For categorical ticks, use the [single-line fitting guidance](#axis-titles-and-tick-labels). Set row spacing and height from the [category geometry recipe](recipes.md#sorting-categorical-axes); do not stretch a short category list to match a longer panel. Keep export and placement widths within the skill's 10% tolerance; enlarging the export and then shrinking it does not solve label fit.

For other text, work through these repairs while preserving the data area:

1. Shorten without changing meaning and adjust typography within rule 6's readable starting ranges, checking the surrounding document.
2. Wrap axis titles and annotations selectively. Reposition an isolated two-line annotation or give its row local space; do not expand every row because of one long annotation.
3. Thin numeric/date breaks, or use `ggrepel` for selected direct labels.
4. Reserve only the necessary annotation space with scale expansion and device margins; the `theme_pub(gutter = ..., base_size = label_pt)` profiles are starting points, not minimum gutters.
5. Change dimensions, layout, or encoding when the required text still cannot fit alongside a useful data display.

Right-side direct labels need a data-space label rail and sufficient device-edge clearance; start with scale expansion and `theme_pub(gutter = "right", base_size = label_pt)`, then reduce any unused space. Off-panel annotations require `coord_cartesian(clip = "off")` and adequate margins, with scale expansion where needed. For categorical ticks, use `scales::label_wrap()` or `stringr::str_wrap()` only for the fixed-placement fallback above.

Reinspect the saved artifact at placement size and in the assembled document after repairs. Apply rule 13's balance check as well as its collision checks; a narrow data strip surrounded by labels and whitespace does not pass merely because nothing overlaps.
