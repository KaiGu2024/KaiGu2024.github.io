# Plan and revise a scientific figure

Use this process for a new figure or a substantial redesign. For a small edit, reuse the existing plan and check the affected content and layout. These are working steps; separate agents, fixed revision counts, and additional user approval are unnecessary.

## Write a compact brief

Use a few lines in the existing script comments or working notes:

- **Purpose:** the question, comparison, or relationship the reader should understand. A diagnostic can pose a question without asserting a result.
- **Evidence:** the source artifact and required values, series, relations, uncertainty, and reference categories. Link to prepared data; do not transcribe every observation into prose.
- **Encoding:** which variables use position, color, shape, or line style; for a diagram, which nodes and connectors carry the argument.
- **Placement:** the intended manuscript or slide size, required labels, and information assigned to the caption or note.

Resolve these from the supplied material whenever possible. Ask only when missing information changes the meaning or intended use.

For example, with a source that supports firm-clustered inference:

> Purpose: show employment estimates across event time, including pre-event diagnostics. Evidence: the saved coefficient and interval table, its omitted period, and source inference settings. Encoding: event time on x; coefficients and supplied intervals on y; zero reference line. Y title: “Effect on employment (percentage points)” or “Employment (percentage points).” Put the omitted period, interval coverage, and firm clustering in the TeX note. Declare placement with `figure_spec()`.

The detailed preparation should produce concise publication text. Apply the [shared notes guidance](../../tables/SKILL.md#concise-notes-without-defensive-prose); do not turn verification records into caveats in the caption.

## Use examples for the problem they solve

Start with the relevant recipe and, when available, a rendered example the user has accepted. Match the comparison, data structure, number of series, label density, and placement size before matching the research topic. An event study is a better reference for another event study than an unrelated chart about the same industry.

Inspect the example itself. Identify the useful choice, such as a label rail, grouping, or uncertainty encoding. Adapt that choice while preserving current semantic, accessibility, brand, and export requirements. Never import the example's findings, causal assumptions, or inference settings.

When retaining a reusable example, pair its render with the source script/data locator, purpose, intended size, useful design choice, and any limits. Mark actual user acceptance only when it occurred. Keep project examples in the project; add examples to the skill library when maintaining that library. A missing example does not block ordinary work or require a web search.

## Review in order

1. **Meaning:** compare with the source and brief. For plots, check data values, variable mappings, transformations, series, intervals, units, and reference periods. For diagrams, check each retained relation and its endpoints against the evidence map. Use structured data or diagram elements where available alongside visual inspection.
2. **Readability:** inspect the saved artifact at placement size, including its host document when produced. Check labels, arrows, marks, and uncertainty for overlap, clipping, ambiguity, and legibility.
3. **Concision and style:** remove repetition and unnecessary decoration while retaining information required for interpretation. Apply the destination's visual standards. A shorter label must still identify the same quantity or relation.

Correctness and readability are acceptance requirements. A more attractive candidate cannot compensate for an incorrect value, missing relationship, or unreadable label. If comparing candidates, use the same evidence and placement size; either or both can fail.

## Repair a specific defect

Identify the affected element, the observed problem, and the smallest useful change: “The end label covers the interval; move it into the right gutter.” Modify the source, render again, and check the repair plus any content or geometry it could affect. Avoid rewriting the whole figure for a local issue.

Retain the last verified source/artifact while revising. Replace it only after the revision passes the applicable checks; if the new layout loses content, restore that content or revert the revision. A successful render alone does not make a candidate better. A missing image, failed review, or malformed automated verdict remains unverified.

Stop when the applicable checks pass and no concrete defect remains. Do not invent criticism to fill a revision quota. Report unresolved issues accurately outside the publication prose.

For the evidence behind these additions, see the [PaperBanana review](../audits/paperbanana-review.md); it is background for skill maintenance, not required reading for each figure.
