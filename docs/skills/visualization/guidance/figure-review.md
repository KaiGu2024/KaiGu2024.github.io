# Plan and revise a scientific figure

For a new figure or substantial redesign, run five separate role agents: **Retriever → Planner → Stylist → Visualizer → Critic**, coordinated by the main assistant. Use the available delegation tools; five role headings in one assistant's response do not constitute separate agents. This workflow applies to statistical figures and conceptual diagrams, including figures created for slides. Keep each artifact's rendering and acceptance rules in its owning skill.

For a small edit, reuse the accepted plan and activate only the relevant roles. A wording correction normally needs the Visualizer and an independent Critic checking the changed label and its layout; a color adjustment may also need the Stylist. A change to the estimand, evidence, relationships, chart type, or overall composition is a substantial redesign and uses the full workflow.

## Coordinate the roles

The coordinator establishes the task, source locations, destination and working directory, dispatches agents, and integrates their handoffs. It retains responsibility for delivery. Give each agent its role, relevant specification fields, source/artifact paths, applicable skill references and required handoff from the table below. Only the coordinator launches role agents; each role works within its assignment and does not recursively launch another figure team when reading a linked skill. No extra user approval is needed to delegate an authorized figure task. Reuse the host document's content map or existing source note rather than requiring another planning document.

The coordinator locates the authoritative inputs and supplies enough source context for retrieval. The Planner owns detailed evidence preparation: for diagrams, acquiring and reading the complete paper and building the evidence map; for plots, inspecting prepared data and inference metadata. Reuse existing verified source records. Choosing a reference does not authorize rerunning an analysis or inventing missing evidence.

| Agent | Inputs | Required handoff |
|---|---|---|
| **Retriever** | User request, source overview, destination, local gallery and available project examples | A short selection of inspected references, each with a locator, matching structural feature and useful design choice; record when none is suitable |
| **Planner** | Original evidence, request and retrieved examples | The shared figure specification: purpose, source mapping, required content, encoding, layout, placement and caption/note allocation |
| **Stylist** | Specification, selected reference renders and applicable visual standards | Concrete choices for typography, palette roles, spacing, grouping and label placement; preserve required content and flag any proposed semantic change for the Planner |
| **Visualizer** | Specification and style decisions, original evidence, renderer-specific rules | Editable source or runnable code, rendered artifacts, exact commands, content checks and paths identifying the candidate revision |
| **Critic** | Original evidence, user request, specification, current source/code, actual saved renders and applicable acceptance checklist | An independent pass/fail/unverified review with located defects and actionable repairs, tied to the exact candidate reviewed |

Run dependent stages in this order. Limited concurrency means queueing role agents, not merging their responsibilities. Preserve handoffs in the shared working note so an agent can finish and release a slot before the next starts. Parallelize only independent figures or work that does not depend on an unfinished handoff. The coordinator owns the shared specification; agents return amendments, and only the Visualizer edits candidate figure files. This avoids competing writes.

Start the Critic in a separate context from the agents that created the candidate, without inheriting their deliberation where the tool allows it. Supply source evidence and artifact paths directly; the Critic must open the saved render and check the evidence, not accept the creator's description or claimed pass. It reports defects without editing the candidate. It may inspect the specification and verification results, but those are not substitutes for the original evidence.

Keep the five roles distinct even when the same model powers them. Do not demand five simultaneous slots or different model providers. If delegation is unavailable or prohibited by higher-priority instructions, execute the roles as explicit sequential passes and mark the review as **self-review; independent review unavailable** in the working record and delivery status. Apply the same content and layout checks; passing them permits delivery with that status, not a claim of independent Critic acceptance or a completed multi-agent workflow. Temporary slot pressure alone is not a reason to use the fallback.

## Keep one shared specification

Use a structured section in the working note, or a small YAML/JSON file when useful. Carry these fields between stages:

- `figure_id`, `revision`, `purpose`, and `artifact_type`.
- `evidence`: source paths/versions and locators; prepared data for plots or the node/relationship evidence map for diagrams.
- `required_content`: quantities, units, intervals, reference periods, series identities, or node/edge IDs and meanings that styling must preserve.
- `encoding`, `layout`, `placement`, `style`, and `references`.
- `outputs`: source/code, rendered artifacts and host-document paths when applicable; identify the candidate with a revision-specific path or content hash.
- `review`: reviewer identity, reviewed revision, checks performed, pass/fail/unverified status and unresolved findings.

Populate fields as the relevant role completes its work. Do not duplicate data tables or the owning skill's rules in the specification. The coordinator resolves routine design decisions; evidence conflicts go back to the Planner. Ask the user only when information that cannot be recovered from the supplied material changes the figure's meaning or intended use.

## Write a compact brief

The Planner's specification should explain the question, comparison or relationship the reader should understand in a few lines. A diagnostic can pose a question without asserting a result. Keep the caption/note allocation explicit so working details do not leak into the artwork.

For example, with a source that supports firm-clustered inference:

> Purpose: show employment estimates across event time, including pre-event diagnostics. Evidence: the saved coefficient and interval table, its omitted period, and source inference settings. Encoding: event time on x; coefficients and supplied intervals on y; zero reference line. Y title: “Effect on employment (percentage points)” or “Employment (percentage points).” Put the omitted period, interval coverage, and firm clustering in the TeX note. Declare placement with `figure_spec()`.

The detailed preparation should produce concise publication text. Apply the [shared notes guidance](../../tables/SKILL.md#concise-notes-without-defensive-prose); do not turn verification records into caveats in the caption.

## Use examples for the problem they solve

The Retriever starts with the [rendered gallery](gallery.md), the relevant recipe, or a suitable example the user has accepted. Match the comparison, data structure, number of series, label density, and placement size before matching the research topic. An event study is a better reference for another event study than an unrelated chart about the same industry.

Inspect the example itself. Identify the useful choice, such as a label rail, grouping, or uncertainty encoding. Adapt that choice while preserving current semantic, accessibility, brand, and export requirements. Never import the example's findings, causal assumptions, or inference settings.

When retaining a reusable example, pair its render with the source script/data locator, purpose, intended size, useful design choice, and any limits. Mark actual user acceptance only when it occurred. Keep project examples in the project; add examples to the skill library when maintaining that library. A missing example does not block ordinary work or require a web search.

## Review in order

The Critic performs these checks independently. Record findings as `element/location → observed defect → required repair`, with the evidence locator where relevant. Record each applicable check as pass, fail or unverified; overall acceptance requires all applicable checks to pass. An empty response or a missing check is not a pass.

1. **Meaning:** compare with the source and brief using the artifact's own acceptance checklist: [plot standards, rule 13](../SKILL.md#1-standards) or the [diagram audit](../../conceptual-framework/references/visual-audit.md). Use structured data or diagram elements alongside visual inspection.
2. **Readability:** apply the same checklist to the saved artifact at placement size, including its host document when produced.
3. **Concision and style:** identify repetition, unnecessary decoration and departures from the destination's visual standards; recommend specific repairs that retain information required for interpretation. A shorter label must still identify the same quantity or relation.

Correctness and readability are acceptance requirements. A more attractive candidate cannot compensate for an incorrect value, missing relationship, or unreadable label. If comparing candidates, use the same evidence and placement size; either or both can fail.

## Repair a specific defect

The coordinator routes the Critic's findings to the responsible role: evidence or encoding issues to the Planner, styling issues to the Stylist, and implementation defects to the Visualizer. The Visualizer applies the agreed repair to the source and renders a new candidate; the Critic then checks the repair plus affected content and geometry. Reuse the role agents for this loop when available. Avoid restarting retrieval or rewriting the whole figure for a local issue.

Retain the last verified source/artifact while revising; create candidates at separate working paths so rendering cannot overwrite the accepted version. Replace it only after that exact revision passes the applicable checks, recording either independent Critic acceptance or the explicitly disclosed self-review fallback above. If the new layout loses content, restore that content or revert the revision. A successful render alone does not make a candidate better. A missing image, failed review, or malformed automated verdict remains unverified.

Stop when the applicable checks pass and no concrete defect remains. Do not invent criticism to fill a revision quota. If repeated repairs make no progress, diagnose the cause and change the approach; if an external constraint prevents completion, retain the last verified version and report the unresolved issue. A resource limit or stopped loop is not acceptance. The coordinator verifies that the delivered files are the reviewed revision. Keep role handoffs and review records outside publication captions and notes.

For the evidence behind these additions, see the [PaperBanana review](../audits/paperbanana-review.md); it is background for skill maintenance, not required reading for each figure.
