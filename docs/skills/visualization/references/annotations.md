# Annotations and axis text

Use this reference when a figure contains direct labels, event annotations, dense tick labels, or axis wording that needs wrapping. The blocking acceptance gate remains in `../SKILL.md` rule 13; code patterns live in `recipes.md`.

## Contents

1. [Direct-label coverage](#direct-label-coverage)
2. [Orientation and contrast](#orientation-and-contrast)
3. [Annotation styling](#annotation-styling)
4. [Axis titles and tick labels](#axis-titles-and-tick-labels)
5. [Unit disclosure across the figure and TeX](#unit-disclosure-across-the-figure-and-tex)
6. [Collision and clipping](#collision-and-clipping)

## Direct-label coverage

Replace legends with direct labels. Label every line or group the reader needs to identify, including backgrounded series in a layer-and-highlight chart. Highlight changes color, not coverage: the focal label uses the focal color; other labels use `grey50` against `grey80` lines.

Do not double-label horizontal bars when their y-axis ticks already name them. If all required series cannot be labeled after using `ggrepel` and an annotation gutter, facet or change the encoding instead of shrinking text.

Keep labels in white space rather than on data marks. Use `nudge_x`, `nudge_y`, or `ggrepel`; reserve `geom_label()` for the rare case where no white space exists.

## Orientation and contrast

Use horizontal annotation prose whenever possible. When a vertical event line or narrow axis forces rotation, use `angle = 90` only: the text reads bottom-to-top, with the reader's head tilting left. Never use `angle = -90` or `270`. Avoid diagonal prose between 15° and 75°.

Short standardized tick labels are different from prose. Dates such as `2024-12` and category strings up to about eight characters can use `angle = 30, hjust = 1` when denser breaks are valuable. For long arbitrary categories, prefer `coord_flip()` over rotation.

Use at least `grey30` on white for annotations meant to be read. `grey60` is too faint for substantive text. Background-series labels may use `grey50` when the corresponding lines are `grey80`.

## Annotation styling

Use `geom_text(size = 7–8)`, approximately 20–22 pt rendered, for direct line and point labels. Endpoint labels that replace a legend may match the 24 pt axis text at `size = 8`. Use Newsreader, inherited from `theme_pub()`, rather than introducing a third typeface.

Write plain nouns of one to three words: `ChatGPT`, `Google`, `Treatment`. Do not add parentheses, qualifiers, units, sample sizes, periods, countries, or model specifications. Put units in axis titles and contextual details in the TeX caption.

For ordinary endpoint labels, use `geom_text_repel(direction = "y")`. When endpoints converge in a narrow vertical band, keep one label rail: rotate labels to `angle = 90, hjust = 0`, anchor each at its endpoint, and repel with `direction = "x"`. If that rail still cannot fit, facet or switch to layer-and-highlight.

## Axis titles and tick labels

Treat axis titles and ticks as the figure's structural text. Follow these rules:

- Use sentence case.
- Spell out the quantity; avoid cryptic abbreviations.
- State the aggregation and unit of analysis: `Mean distinct foundation models per language`, not `Distinct foundation models`.
- Put the unit in parentheses at the end: `Referral share (%)`, `Response time (ms)`.
- Keep titles to roughly three to six words. Use `labs_pub()` to wrap at 32 characters for x titles and 26 for y titles by default.
- Use `y = NULL` only when y-axis ticks already name every item, as in sorted horizontal bars.
- Format ticks with `scales::label_*`; avoid raw long numbers and scientific notation. Aim for about six characters per tick label. Keep dates in ISO `%Y-%m`.

When a title is too long, shorten or wrap it before increasing margins. Do not replace a precise axis title with an in-figure title or subtitle.

## Unit disclosure across the figure and TeX

Use three complementary layers:

1. **Axis label:** state the metric and aggregation, such as `Median parameters per foundation model`.
2. **LaTeX caption or panel subtitle:** identify the population or analytical object, such as `Foundations adopted for low-market languages`. For a single-panel figure, the caption performs this role.
3. **Figure note:** state what one observation represents, the universe, denominator, sample size or missing-data coverage, and exclusions, such as `Unit: one registry-recognized foundation model; 25 of 27 adopted foundations have measured parameter counts.`

Make the layers complement rather than repeat one another. Before acceptance, compare them with the code's aggregation and the surrounding prose; all must describe the same unit, population, and denominator.

## Collision and clipping

Apply repairs in the order specified by the acceptance gate:

1. Shorten or wrap text.
2. Thin breaks, use `guide_axis(n.dodge = 2)`, or flip long categorical axes.
3. Create a data-scale annotation gutter with `expand`.
4. Use `ggrepel`.
5. Select a `theme_pub(gutter = ...)` profile or increase the relevant device dimension.
6. Change the layout or encoding.

Right-side direct labels require both scale expansion and `theme_pub(gutter = "right")`. Off-panel annotations require `coord_cartesian(clip = "off")`, matching scale expansion, and the relevant margin profile. Wrap long category labels with `scales::label_wrap()` or `stringr::str_wrap()` before enlarging the left gutter.

Never solve overflow by shrinking text below the minimum sizes in `../SKILL.md` rule 6. Open and inspect the saved artifact at placement size after every repair.
