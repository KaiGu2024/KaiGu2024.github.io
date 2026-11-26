# Writing notes for delivery

Adapted from the repository's human-reading guide, `docs/skills/human-reading/presentation.md`. The practical guidance is included here so installed copies of the slide skill remain self-contained. Apply it as full spoken sentences in `own` mode and brief speaking cues in `report` mode; preserve each mode's slide order.

## Paragraph breaks are pause cues

Write each paragraph as one speaking unit: a connected thought the presenter can deliver before looking up. Usually one to three short sentences are enough. Break when moving from an example to its meaning, from a result to its interpretation, or from an explanation to the next question. Keep a number with its units and a qualification with the claim it limits. Do not split mechanically after every sentence or leave an entire slide's narration in one dense paragraph.

A visible blank line means a deliberate pause: roughly one to two seconds, with a glance at the audience before continuing. Sentence endings usually need only a shorter breath. Allow longer after a central finding or while the audience locates a feature in a figure. These are rehearsal starting points, not fixed pauses to impose regardless of the room; include them in the slide's time budget.

In Beamer, separate speaking units with a blank source line or `\par` inside `\note{...}` and give note paragraphs visible vertical spacing. A source newline or `\\` alone is not a paragraph break. In Reveal.js, use one `<p>` per speaking cue and retain visible margins between them. A very short note may need only one paragraph. Do not pad it to meet a paragraph quota.

## Bold marks vocal emphasis

Bold the exact word or short phrase that should receive spoken stress: the key comparison, main magnitude with its units, defining term, or necessary qualifier. Use `\textbf{...}` in Beamer, `<strong>...</strong>` in HTML, and `**...**` in a Markdown rehearsal script. Apply the cue to words the speaker will actually say; a bold organizational label such as “Evidence” alone does not tell them what to emphasize.

Choose emphasis sparingly, often one or two short spans in a paragraph when useful. Leave most text in normal weight. Do not bold whole sentences, every technical term, or only names and headings. Stress must preserve the claim's meaning: keep “about,” “conditional on,” or “associated with” audible when they matter, and never use emphasis to make an uncertain result sound definitive. Bold means vocal stress, not a separate pause after each marked phrase.

## Write for the ear

Use the language of a clear explanation to a colleague. Prefer short clauses, concrete subjects, active verbs, and familiar connectors such as “So,” “But,” or “That gives us…” where they fit. Use contractions naturally, without forcing them into every sentence. Use “we” for the author's own work and “the authors” for a report on someone else's work. Preserve technical precision while replacing written-paper phrasing: “We compare articles from the same year and topic” is easier to say than “Our empirical specification conditions on temporal and topical covariates.”

- Give one main thought per sentence. Split nested clauses, long lists, and parenthetical asides into sentences the listener can follow on first hearing.
- Define an unfamiliar term before relying on it; say what a symbol measures rather than reading an equation character by character. Write numbers and units as they will be spoken, such as “3.2 percentage points,” not just “+3.2 pp.” Preserve exact estimates and qualifications.
- Point to the feature you want the audience to find and give them time to look. Use the walkthrough below when introducing a figure or table.
- Use a specific question or transition when the argument needs one: “How much of that information is new?” can connect coverage to novelty. Avoid a repetitive “Now let's move on to…” on every slide.
- Let a key term recur when listeners need the reminder. Avoid ornamental synonyms, stock enthusiasm, invented audience reactions, and filler added merely to sound conversational.
- Keep optional Q&A answers and stage directions distinguishable from words to say. Use paragraph spacing for ordinary pauses; reserve a short bracketed cue such as `[point to the right-hand estimate]` for an action that prose alone would not make clear.

In `own` mode, the paragraphs should form a complete, sayable explanation, not bullet fragments or a manuscript abstract. In `report` mode, preserve brief cues: use natural short phrases and selected spoken sentences rather than expanding the overlay into a script. See the mode references for worked markup examples.

The delivery conventions above were informed by the user's twelve-minute `main_notes.pdf` (notes for slides 2 and 10, PDF pages 4 and 20) and its companion `notes/speaker_notes.md`, reviewed on 2026-10-14. The PDF shows separated speaking units, selective bold emphasis, and direct visual pointers; the companion explicitly explains the pause convention. The original example is at `D:/ObsidianVaults/Kai_and_Kai/wiki_content/output/slides/12min/`. This is provenance, not a runtime dependency or a source of research claims for new decks; use the conventions without copying incidental wording or errors.

## Continuity between slides

Draft notes in talk order, with the preceding and following slide in view. Before writing a transition, identify what the audience has just learned and why the next idea follows: a question needs an answer, a finding needs an explanation, or a concern needs a diagnostic. Express that substantive relationship in ordinary spoken language. Naming the next section alone does not establish the connection.

Use one bridge per slide boundary when needed. Put it at the end of the current note or the beginning of the next; do not announce the same move twice. If the next sentence already continues the explanation clearly, no separate bridge is necessary. Vary the form naturally: a direct continuation, a short question, or a statement of what remains unresolved. Do not turn every slide ending into a rhetorical question.

Keep references clear across the slide change. “This,” “that pattern,” and “these effects” must have an unmistakable referent; repeat a short substantive phrase when needed. Do not point to a feature of the next slide before it is visible. After an interruption, restore the relevant comparison briefly before continuing.

For example, if supported by the actual results:

> End of results slide: “So purchases increase overall. But that still leaves open **who is responding**.”
>
> Start of the next slide: “Here, we separate first-time buyers from returning customers.”

The second note takes up the question directly; it needs no additional “Now let's look at who responds.” These are illustrative speaking patterns, not findings to copy into a deck. In `report` mode, retain only the brief cues needed to make the same connection.

Review every planned slide boundary by reading the last paragraph of slide A immediately followed by the first paragraph of slide B (or the corresponding cues in `report` mode). Check for repeated setup, missing reasoning, unclear references, and a promised question or explanation that the next slide does not address. Revise the two notes together. Repeat this check at boundaries changed by reordering or skipping optional slides, then read the full narration continuously.

The title follows its mode-specific opening. A conclusion closes the argument and may invite discussion; it does not need to lead into another content slide. A standalone backup note answers the question that brings it into use, without assuming that the preceding or following backup slide will be shown. Add a brief return to the main argument only when useful.

## Opening and motivation

In `own` mode, use the title slide for the personal opening in [own-work.md](own-work.md#title-slide-opening). In `report` mode, introduce the paper and credit the authors. Begin the substantive explanation on the first Motivation slide in both modes.

Assume the audience is hearing about the paper for the first time. Put a broad question or a verified concrete example on the first substantive slide. Explain who or what is affected, what is puzzling, and why the answer matters. Define paper-specific terms as they become necessary. Aim to establish this context within the opening ninety seconds, including the personal introduction in `own` mode.

In motivation, explain why the question matters, why it is hard, and what the data or setting make possible, in that order. Name the tempting naive comparison and explain its specific failure in plain language. In `own` mode, follow Motivation with Literature Positioning, then present the formal research question and findings preview on one combined slide or two consecutive slides, depending on the length and complexity of the findings. Use sourced examples from the paper or permitted motivation evidence; illustrative numbers in a writing guide are not evidence for the deck.

## Explaining the design and results

Describe what changed in the world before naming the estimator. Make the institutional rule, treatment variation, unit of observation, and comparison intuitive. Say what the data omit and why that matters. Explain an equation's purpose before asking the audience to parse its symbols.

Walk the audience through the evidence before interpreting it:

- For a figure, name the x-axis and y-axis with units, then explain the relevant groups, marks, reference lines, and uncertainty. Flag any change in scale across panels. For a diagram, explain what the main elements and arrows represent.
- For a table, name what the rows and columns represent, identify the units and comparison group, and point to the cell or contrast that answers the question. Explain how the table shows uncertainty when it is reported.
- Pause while the audience finds the relevant evidence. Say the headline number aloud with its units, comparison or baseline, and available uncertainty. Explain what the evidence means for the question. When the same visual conventions recur, give a brief reminder and explain anything that changed.

Give each substantive panel, bullet, or comparison a purpose in the narration. Cover a related set of points or cells as a pattern. Move secondary evidence to backup, and give substantive claims and qualifications a visible anchor. State limitations directly and explain their consequence for interpretation. For example, “Each model was evaluated on a different sample, so the cross-model comparison is descriptive.” For an imprecise estimate, say which effects remain compatible with the interval.

## Anticipating objections and interruptions

Identify two or three questions the evidence is likely to raise. Connect each to a sourced diagnostic, robustness result, or scope condition. Put the decisive evidence in the main talk and additional evidence in numbered backup slides. Keep optional Q&A answers and backup-slide references in the preparation notes.

- Answer clarification questions in one sentence where possible.
- Give an objection a short direct answer, then show the relevant evidence if needed and return to the interrupted argument. Aim for about thirty seconds initially; a necessary evidence detour can take longer.
- Acknowledge a long tangential contribution briefly, answer its substantive point, and offer to continue afterward.
- If the evidence cannot answer the question, say so. Never invent a robustness check or promise a result that is not available.

Write transitions that help the presenter resume after interruptions: remind the audience of the comparison or claim being developed without restarting the entire section.

## Closing

Return to the opening question, answer it with the same headline magnitude, and state the implication for theory, policy, or decisions. Include the main scope condition in the spoken explanation. Leave this substantive conclusion visible during questions; verbal thanks need no separate slide. In `report` mode, bridge from that summary to the most useful discussion question. In `own` mode, finish on the implication supported by the evidence; do not replace the answer with a list of future projects.

## Pacing and rehearsal

Record the available time, whether Q&A is included, and a block-level time budget in `notes/<slug>.md` before drafting the deck. If the duration is unspecified, state a working assumption. Budget interruptions explicitly and make the allocations sum to the total slot.

- For a twenty-minute `own` slot including questions, one starting allocation is opening/motivation 2 minutes, literature positioning 1, question/findings preview 1 across either one or two slides, context/data/design 3, main results 6, mechanism/decisive robustness 3, conclusion 1, and questions 3. Compress supporting material while preserving the mode's required blocks.
- For an eighty-minute `own` seminar including interruptions, one starting allocation is opening/motivation/positioning/question and preview 10 minutes, context/data 10, design 10, main results 15, mechanism/heterogeneity 10, decisive robustness 5, conclusion 5, and interruptions 15.

These are planning examples, not fixed durations. A short talk needs fewer claims and less supporting detail; speeding up the same long deck is not a substitute. Mark optional slides and a route to the conclusion in the preparation map. Adjust note lengths to the actual slide budget: a central result may need several minutes, while a title slide may need only a few sentences.

Rehearse a five-minute account of the question, comparison, finding, and implication aloud. Use the opening and the hardest figure for three short delivery passes: very excited, sad, and upset. Keep the claims fixed and notice how your pace, pauses, and emphasis change. Carry the clearest choices into your natural delivery.

Then time the full talk aloud with the actual slides. Look up at paragraph breaks, give the audience time to find the evidence, and practice pointing as you speak. Rewrite awkward sentences and cut secondary material to fit the slot. Check the route to the conclusion after a substantial interruption. Label a text review or estimated timing as such.
