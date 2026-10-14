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
- Orient the audience before interpreting a visual: “Look at the estimates on the right” should identify an actual feature of that slide. Then explain what it means. Allow time for the audience to look.
- Use a specific question or transition when the argument needs one: “How much of that information is new?” can connect coverage to novelty. Avoid a repetitive “Now let's move on to…” on every slide.
- Let a key term recur when listeners need the reminder. Avoid ornamental synonyms, stock enthusiasm, invented audience reactions, and filler added merely to sound conversational.
- Keep optional Q&A answers and stage directions distinguishable from words to say. Use paragraph spacing for ordinary pauses; reserve a short bracketed cue such as `[point to the right-hand estimate]` for an action that prose alone would not make clear.

In `own` mode, the paragraphs should form a complete, sayable explanation, not bullet fragments or a manuscript abstract. In `report` mode, preserve brief cues: use natural short phrases and selected spoken sentences rather than expanding the overlay into a script. See the mode references for worked markup examples.

The delivery conventions above were informed by the user's twelve-minute `main_notes.pdf` (notes for slides 2 and 10, PDF pages 4 and 20) and its companion `notes/speaker_notes.md`, reviewed on 2026-10-14. The PDF shows separated speaking units, selective bold emphasis, and direct visual pointers; the companion explicitly explains the pause convention. The original example is at `D:/ObsidianVaults/Kai_and_Kai/wiki_content/output/slides/12min/`. This is provenance, not a runtime dependency or a source of research claims for new decks; use the conventions without copying incidental wording or errors.

## Opening and motivation

In `own` mode, use the title slide for the personal opening in [own-work.md](own-work.md#title-slide-opening): greet and thank the audience, introduce the presenter and affiliation, say the project title, and acknowledge coauthors. Start the substantive explanation on the first Motivation slide. In `report` mode, retain the brief title-slide hook specified in [speaker-notes.md](speaker-notes.md); do not describe someone else's paper as the presenter's joint work.

Use the opening motivation to make the audience curious. Begin that substantive explanation with one verified, concrete object: a number, an institutional fact, a quotation, or a pattern in a graph. Explain the tension it creates and the question it raises. Keep this early enough to engage the audience within roughly the first ninety seconds, including the personal introduction in `own` mode. Avoid a list of methods or a spoken table of contents before the audience understands why the question matters.

In motivation, explain why the question matters, why it is hard, and what the data or setting make possible, in that order. Name the tempting naive comparison and explain its specific failure in plain language. In `own` mode, follow Motivation with Literature Positioning, then present the formal research question and findings preview on one combined slide or two consecutive slides, depending on the length and complexity of the findings. Use sourced examples from the paper or permitted motivation evidence; illustrative numbers in a writing guide are not evidence for the deck.

## Explaining the design and results

Describe what changed in the world before naming the estimator. Make the institutional rule, treatment variation, unit of observation, and comparison intuitive. Say what the data omit and why that matters. Explain an equation's purpose before asking the audience to parse its symbols.

For each result, say the headline number aloud with units, the comparison or baseline, and available uncertainty. Direct attention to the relevant point, interval, or pattern in the visual, then explain what it means for the question. Do not read every coefficient or visible bullet. Distinguish evidence for a mechanism from evidence that rules out an alternative; describe null or imprecise heterogeneity with its uncertainty rather than treating it as proof of uniform effects.

## Anticipating objections and interruptions

Identify the two or three most credible objections during preparation. For each, connect the concern to a sourced diagnostic, robustness result, or acknowledged limitation. Put the decisive evidence in the main talk and additional defenses in numbered backup slides. Where useful, include a short answer and a backup-slide reference in the relevant note; keep optional Q&A material separate from the planned narration so it does not inflate the speaking-time estimate.

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

Rehearse a coherent five-minute account of the question, comparison, finding, and implication. Then time the full talk aloud, honoring paragraph pauses, bold stress words, and time to read figures. Rewrite any sentence that needs an awkward breath, any bold phrase that sounds overplayed, and any transition that sounds scripted. Revise notes and slide count to fit; do not recover time by removing all pauses or accelerating through the main finding. A word count alone does not establish delivery time. Check that the talk can still reach its conclusion after a substantial interruption.
