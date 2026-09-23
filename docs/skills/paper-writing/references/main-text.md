# Main Text — shared drafting guidance

Read this guide and [academic voice](academic-voice.md) when using paper-writing. This file owns shared substantive rules and routes to section-specific guidance; academic voice owns wording, sentences, paragraphs, and pacing. Read only the section guides needed for the requested task. Their names describe argumentative functions, not mandatory manuscript headings or numbering.

## Section guides

| Guide | Purpose |
|---|---|
| [Abstract](sections/abstract.md) | Compress the conceptual problem, empirical object, answer, and significance. |
| [Introduction](sections/introduction.md) | Motivate the question, preview the study and findings, position contributions, and give the roadmap. |
| [Conceptual Framework](sections/conceptual-framework.md) | Position constructs and theoretical relationships within relevant literatures and develop the study's conceptual reasoning. Initial scope guidance; detailed development remains open. |
| [Data and Methods](sections/data-and-methods.md) | Explain what is observed, how constructs are operationalized, and what the design and analysis can establish. |
| [Results](sections/results.md) | Organize findings and decisive evidence around the paper's questions. |
| [Discussion](sections/discussion.md) | Develop implications, limits, and the concluding change in understanding. |

For framing and compression, use **construct lock → evidence hierarchy → substantive compression**: establish meanings using the construct lock below, select evidence using the [abstract guide](sections/abstract.md#select-evidence-by-its-job), and shorten without widening claims. The conceptual framework develops the argument; Data and Methods makes its empirical representation and inferential limits explicit. Section order and separation follow the project.

## Supporting evidence

The four files in `evidence/` are background records, not routine drafting instructions. Read them when checking provenance, comparing exemplars, or revising the guidance:

- [Introduction audit](evidence/introduction-three-paper-audit.md): three empirical papers, exact versions, and paragraph maps.
- [Academic-voice audit](evidence/academic-voice-three-paper-audit.md): prose observations and paragraph/sentence counts, with counterexamples.
- [Academic-voice sources](evidence/academic-voice-sources.md): writing principles, empirical research, and scope limits.
- [Award-paper patterns](evidence/award-paper-patterns.md): an earlier broader evidence record. Its historical drafting prescriptions are superseded by the current section guides; do not treat its sample descriptions as universal requirements.

These guides are adaptable editorial guidance for empirical economics, management, information systems, and marketing. Match the paper's contribution, the author's requested scope, and verified venue constraints. No section guide or audit establishes a journal requirement.

---

## Cross-cutting writing rules

Distilled from McCloskey's *Economical Writing* and Cochrane's *Writing Tips*:

- **Make the substantive result easy to find.** Give enough problem and comparison context for the result to mean something; in abstracts, select quantitative anchors rather than opening automatically with a number.
- **Concrete numbers beat vague summary.** "N = 14,203, 47 duplicates removed, 0.3% missingness on the outcome" beats "the dataset was cleaned."
- **Report uncertainty where estimates are presented and defended.** Results text and tables should supply SEs, intervals, or appropriate uncertainty measures. A short abstract need not repeat every SE, but must retain uncertainty that changes its conclusion, especially for nulls or imprecise contrasts. Never invent missing precision.
- **Subjects, cadence, and signposting.** Follow the [calibrated prose defaults](academic-voice.md#calibrated-defaults): choose informative subjects, preserve inferential links, and keep transitions that do real work. First person, sentence length, and particular phrases are contextual choices.
- **Bold key terms, numbers, conclusions.** Matches the [report](../../report/SKILL.md) convention.
- **Use → for logic chains.** "high churn → low LTV → unprofitable segment." Matches [report](../../report/SKILL.md).
- **Write early and revise for purpose.** Writing helps develop the argument before analysis is finished. Remove unnecessary words while retaining or adding the explanation needed to follow the inference.
- **Audience: the busy referee.** Imagine them on a train, with thirty minutes, deciding among reject / R&R / accept. Write so they can decide on the abstract and intro alone.
- **Offload the banal, protect the important.** Boilerplate emails, regression-table summaries, section roadmaps, and reference-list cleanup are safe targets for LLM assistance. The wedge sentence, the framing, the contribution paragraphs, and the limits paragraph are not.

### Substantive compression and local qualification

Translate methods into messages without translating away evidentiary boundaries. Keep the comparison, population or subsample, time window, measurement definition, and inferential status wherever omitting them would change a reasonable reader's interpretation.

- **Combine corroboration into a substantive clause.** In a hypothetical content study, replace "The fact analysis corroborates the sentence analysis" with "The more-transfer, fewer-additions pattern also appears in fact-level measures in the four-edition subsample," if both patterns are actually supported. "In the fact sample" suffices only if that sample's restricted scope is already clear; an abstract must stand alone.
- **Preserve numerators and denominators.** Fewer local facts can coexist with a larger share among remaining additions. Say both if central, and identify the denominator. Do not turn a rising share into a rising count or substitute a compositional shift for an absolute gain.
- **Qualify at the claim.** Prefer "is associated with," "a descriptive comparison around the service integration," "model-implied," or "under the assumed deployment scenario" to an overstrong claim followed by a corrective disclaimer. A separate limitations sentence remains appropriate when the boundary governs the whole paper and cannot be made clear locally. Preserve causal language when the design genuinely warrants it; local qualification does not mean blanket hedging.
- **Do not upgrade the event.** An optional service integration is not necessarily a generic technology advance, mandatory adoption, or exposure to improved technology. Preserve what actually changed and who could be exposed. An estimator label alone does not license a causal interpretation.
- **Keep simulations conditional.** "Under the assumed substitution scenario, deployment reduces independent additions" retains what "the simulation has managerial implications" leaves empty. Use only the outcome and assumptions actually supported; do not present modeled deployment consequences as observed platform behavior.

Compress wording and secondary detail, not the identity or strength of the claim. Unknown definitions and missing evidence need a focused question or a visible placeholder, not an elegant invented bridge.

---

## Working with Claude on prose

Drafting a paper with an LLM is a thinking exercise, not a typing exercise. The risk is **cognitive offloading** — the model produces text faster than you can think, and you accept it because it reads well. Goldsmith-Pinkham's rules, adapted:

### Personal style guide

Build a `writing_style.md` from your own published work:

1. Collect five to ten pieces of writing you are satisfied with — published papers, referee reports, blog posts, memos.
2. Ask Claude to extract patterns: sentence length distribution, hedging language, transition verbs, paragraph-opening structures, where you place numbers, how you handle citations in prose.
3. **Curate the output.** Delete what is wrong, add what the model missed, soften rules that are too rigid. The first version always misses things — iterate after every paper you write.
4. Reference it in every drafting prompt: "Edit the following section against `writing_style.md`."

The output will be **recognizable but caricatured** — a shadow of your real voice, not a mirror. Treat the guide as a constraint that pushes prose in better directions, not as voice capture. Nabokov's caveat: writing quirks are often deliberate stylistic choices; do not let the guide flatten them.

**Maintain separate guides per register.** Academic paper, referee report, blog post, slide deck — these have different rules, and one merged guide will produce prose that fits none of them.

### Comments, not rewrites

For a requested critique or comment pass, a useful editing prompt is:

> *"Edit the following section in the style of a NYT editor for writing and clarity. Do not edit my text directly. Instead, insert inline comments where the argument is poor, the prose is unclear, or a claim is unsupported."*

Why this works:
- The original text is preserved; you read each comment and decide your response.
- Forces active engagement — you cannot passively accept LLM prose because no LLM prose is produced.
- Preserves voice. The most common failure mode of LLM-assisted writing is unintended convergence to the model's average style; comment-mode blocks that.

Use Claude Code (or another file-aware harness) for this — the chat web UI cannot read and annotate the actual draft cleanly.

### The AI tells — a self-audit

Start with substance, not a phrase blacklist. For every abstract sentence, ask: **does it tell the reader something about the phenomenon, evidence, or contribution, or merely announce what an analysis or section does?** "The simulation provides managerial implications" names a rhetorical job, not a finding. "Under the modeled scenarios, outcomes depend on whether assistance supplements or replaces independent production" earns its space only if those scenarios and outcomes are supported. Apply the [substantive-compression rules](#substantive-compression-and-local-qualification) to replace empty analysis inventories. Ordinary transitions such as "Taken together" are not defects when followed by a precise, warranted inference.

Convergence to the model's average style has a recognizable surface. If a draft carries several of these, a reader is already discounting it — they read it as *you did not think hard about this*. Audit your own prose for:

- **The cliché phrasebook** (representative, not exhaustive): "it's not just X — it's Y", "more than just a [X]", "at the heart of", "stands as a testament to", "navigate the complexities of", "leverage / harness / tap into", "shed light on", "revolutionizes the industry", "game-changer / paradigm shift", "robust, scalable, seamless", "in today's rapidly evolving landscape", "a tapestry of", "delve into", "underscores the importance of", "a myriad of", "ushers in a new era of".
- **Pet tics:** the overused "moat" (build / widen / deepen / strengthen the moat) and the reflexive em-dash. (Yes — like that one.)
- **Three structural patterns**, harder to grep than the phrasebook:
  1. **Exception constructions** — "not just X, it's Y", "this isn't about A, it's about B". The shape performs depth without earning it; a real claim usually doesn't need the scaffolding.
  2. **Overgeneralizations** — "every customer wants…", "always / never / all / none". Empirical claims live in conditions and tradeoffs; sweeping language signals the writer skipped them.
  3. **Broad strong claims** — "revolutionizes", "fundamentally redefines" — used to substitute for evidence. Scope each claim to what the analysis actually supports.

**Verb strength ≤ evidence strength.** The greppable form of the "broad strong claims" tell: no verb outruns the evidence behind it. Empirical work *shows*, *provides evidence*, *is consistent with* — it does not *prove*, *demonstrate*, *establish*, *confirm*, or *guarantee* a universal truth. Watch the same list plus "significantly" used with no test or number attached. Downgrade the verb, or attach the number and test that would license the stronger one ("*prove* our method is better" → "improves held-out accuracy by 4–7 points over the strongest prior estimate, significant at p < 0.01").

**Preserve — the over-correction failure mode.** The audit above is one-directional: it removes tells. Run it too hard and you introduce the opposite defect — flattening the calibrated hedging that scholarship *requires*. Turning "the results suggest X" into "the results show X" does not de-AI the prose; it manufactures an over-claim. Before deleting, check that you are not stripping a legitimate construct:

  - **Evidence-tied hedging is correct and stays.** "suggests", "is consistent with", "we hypothesize that", "may indicate", "appears to" — keep them whenever the claim is genuinely uncertain. A calibrated verb is not a tell.
  - **Passive voice is fine when the actor is irrelevant** — "samples were normalized to total protein." Recast passives only where naming the agent adds information (see [academic voice](academic-voice.md#calibrated-defaults)).
  - **First-person plural "we" is standard** — do not rewrite to avoid it.
  - **Semicolons and an occasional triple** are fine in moderation; judge em-dashes by their function and frequency, following academic-voice; no punctuation is banned outright.
  - **Definitions, named methods/metrics, symbols, equations, and every number and citation stay verbatim.**

  The two disciplines run together: remove the tells, but never at the cost of a verb that was correctly calibrated to its evidence.

**Why it matters (the empirical case):** detectably-AI work is penalized by evaluators (Reif/Larrick/Soll 2025; Raj/Berg/Seamans 2026), and over-reliance homogenizes output — more text per author, fewer distinct ideas across a field (Anderson 2024; Doshi & Hauser 2024; Moon 2025). Distinctiveness is the asset; generic confidence is not a substitute for specific reasoning. (Adapted from the MGMT430 *"Using AI without sounding like AI"* lecture; the slide-deck counterpart — *visual* tells — lives in [`slide/references/aesthetics.md`](../../slide/references/aesthetics.md).)

### The accountability test

Before sending a draft to a coauthor or referee, ask: *"Can I defend every paragraph in this section without the LLM open?"* If the answer is no for any paragraph, that paragraph is not yet yours. Rewrite it by hand, or delete it. The 1977 IBM rule — a computer cannot be held accountable, therefore a computer cannot make the editorial decision — applies to every sentence the paper claims under your name.

Do not draft with Claude when tired. The output looks fine and isn't, and you stop pushing back.

---

## Strict-traceability mode

The section guides are flow-first: establish the argument, choose the relevant moves, and polish later while keeping claims grounded. **Strict-traceability mode** makes that grounding explicit claim by claim: accept no claim that doesn't trace to a specific input, and flag every gap. Use it when the cost of an invented number outweighs the cost of a slower draft.

**When to switch on:**

- Methods sections — one fabricated detail sinks credibility
- Results sections drafted directly from regression output, where misreading a coefficient is unacceptable
- Discussion sections drafted against fieldnotes or interview matrices, where misattributing a quote breaks trust
- Any section the user wants to read with the inputs open in another window and check claim-by-claim

The accountability test under [Working with Claude on prose](#working-with-claude-on-prose) — *"can I defend every paragraph without the LLM open?"* — is the same idea applied at paragraph granularity. Strict-traceability mode applies it at *claim* granularity.

**Three rules — non-negotiable:**

1. Every empirical claim traces to a `file:line` in the input. If it cannot, the line gets `[TODO: source]`.
2. Every reference to a paper, dataset, or method uses a `[CITE: short-handle]` placeholder. Never invent author-year strings.
3. Numbers absent from the input become `[TODO: number]` placeholders. Never guess a coefficient, p-value, or N.

**Workflow:**

```
identify section + inputs → load template → map inputs to slots → draft → emit TODO/CITE checklist
```

Section templates (Methods / Results / Discussion slots) live in [`report`](../../report/SKILL.md) §Paper-section Templates. Map each slot to the input that supplies it; slots with no source become `[TODO]` markers, never silent omissions.

**Inline source attribution** — flag the source as the finding is stated:

> Treatment increased click-through by 12.4% (p < 0.01) [source: `analysis.R:184`].

If the input doesn't contain the claim:

> Treatment increased click-through by [TODO: number]% (p [TODO: p-value]) [source: TODO].

**Closing checklist** — append after the draft so the revision pass is concrete:

```
## TODO
- [ ] line 23: number for treatment effect (could not find in inputs)
- [ ] line 41: citation for "scarcity messaging literature"

## CITE placeholders
- [CITE: cialdini1984] x3
- [CITE: kahneman2011] x1
```

The gap inventory is visible — every line that needs a number, every reference that needs resolving — before the section is circulated. Pair with [`literature-review`](../../literature-review.md) Path A to resolve `[CITE: handle]` strings into verified DOIs.

---

## Construct lock and terminology anchoring

### Within-paper construct lock

Before drafting or compressing the abstract and introduction, map the central terms from the supplied paper, especially those in its title and headline contribution:

`term → exact meaning → allowed shorthand → misleading near-synonyms`

Keep this map internal for a small edit; show only unresolved definitions or consequential choices. Reserve each load-bearing term for its defined construct across the title, abstract, and introduction, and check that Results and the conclusion use it consistently. A stylish synonym must not change the measured object, reference set, or theoretical claim. Literature familiarity alone cannot guarantee within-paper consistency.

For illustration only, a paper might define *expansion* as growth in target content, *transfer* as source information represented in the target, and *enrichment* as additions relative to that source. In that paper, casually calling transfer "expansion" would blur the title's distinction; calling enrichment "new knowledge" would add truth and novelty claims not supplied by a source comparison. Derive the actual map from the manuscript, not this example. A phrase such as *knowledge stock* requires its own explicit definition and accounting boundary, not an assumed synonym for total content.

If title and body definitions conflict, flag the conflict rather than silently choosing the catchier meaning. Proposed renaming is an author decision; propagate an approved choice consistently. For title generation itself, use the separate paper-titles skill when available.

### Literature anchoring

A draft can be structurally clean and still name its objects wrong. When a paper coins its own label for a construct the literature already names — "engagement decay" for what the field calls *churn*, "attention spillover" for *demand cannibalization* — the referee reads it as not-having-read-the-literature, and the contribution gets discounted before the result is even weighed. The fix is not to flatten every term into the nearest cliché; coining is sometimes the contribution (a deliberately introduced new construct). It is to make the choice **deliberate**: anchor to the literature's term where you are describing a known object, and reserve a coined term for where you are genuinely introducing one.

This terminology-anchoring check is a **polish pass**, run after the draft has structure and content; the local construct lock above starts before drafting and does not require a new literature search. Substantive literature grounding belongs in the argument from the start, especially in the [conceptual framework](sections/conceptual-framework.md). This later check addresses naming consistency. The anchoring pass round-trips with [`literature-review`](../../literature-review.md): the skill that resolves `[CITE: handle]` strings is the same one that knows how the anchoring papers name each construct.

**When to run it.** When terminology needs checking, after substantive drafting, before the [`academic-voice.md`](academic-voice.md) pass. Especially when the paper sits on top of an established literature whose vocabulary the referee will expect, or when the draft was written fast and may have drifted into ad-hoc labels.

**Three steps:**

1. **Extract the construct/method terms.** Scan the section for the nouns and noun phrases that name an economic object, a mechanism, a measure, or a method — the words a referee would expect to map onto a known concept. Skip ordinary prose; collect the load-bearing terms. Output a list, each with the sentence it appears in, so the term is judged in context (the same word can be load-bearing in one sentence and incidental in another).
2. **Find the literature-anchored term for each.** Hand the list to [`literature-review`](../../literature-review.md) Path A: for each extracted term, retrieve how the anchoring papers (the ones the paper already cites, plus the canonical refs for that construct) name the same object. Some terms will map cleanly to a standard label; some will have two or three competing conventions; some will have no established anchor, which is itself the signal that the term may be a genuine coinage.
3. **Emit a diff, never a silent rewrite.** For each term, propose: keep, or replace with the anchored term — with the citation that licenses the anchored choice and a one-line reason. The author decides. Three verdicts:
   - **Anchor** — the draft drifted from a settled term; replace it and cite. ("'engagement decay' → *churn* [CITE: reichheld1996]; field uses *churn* for exactly this hazard.")
   - **Choose** — two or three conventions compete; surface them with their citations and let the author pick the one whose framing fits the contribution. Do not pick silently.
   - **Coin** — no established anchor, or the author is deliberately introducing a construct. Keep the term, but flag that it needs an explicit definition for the new construct, and that it should *not* be quietly swapped for a near-synonym elsewhere in the paper.

**Output shape** — a per-term table the author reads top to bottom:

```
## Terminology anchoring
| Draft term | Verdict | Anchored term | Licensing cite | Note |
|---|---|---|---|---|
| engagement decay | anchor | churn | [CITE: reichheld1996] | settled term for this hazard; draft drifted |
| attention spillover | choose | cannibalization / demand diversion | [CITE: ...] | two conventions; pick by framing |
| trust transfer | coin | — | — | no anchor; define it explicitly, don't synonym-swap later |
```

The discipline mirrors [strict-traceability mode](#strict-traceability-mode): the skill never silently changes the word the author chose — it surfaces the literature's term, the citation that licenses it, and the reason, then leaves the editorial decision with the author. Anchoring to a borrowed term and coining a new one are both defensible; drifting into an ad-hoc label by accident is not.

This pass also feeds the `feedback_prose_restraint` discipline ("prefer literature-anchored terms") with a mechanism rather than a reminder: the anchored term comes back with a verified citation, not from model memory.

---

## How `report.md` artifacts feed into the paper

| Report artifact | Lands in |
|---|---|
| §1 Data & Sample | Intro's empirical setup + Data section + Abstract's empirical-object move |
| §2 Definitions | Measurement section (brief in body, full in appendix) |
| §3 Findings | Results subsections; empirical setup, figure/table, and description preserved |
| §Heterogeneity | Its own Heterogeneity section |
| §Benchmark | Discussion / Comparison subsection before the conclusion |
| §Limitations | The honest-limits paragraph in the conclusion |

The flow: [brainstorm.md](../../brainstorm.md) develops a question → [literature-review.md](../../literature-review.md) grounds it and [eda.md](../../eda.md) explores the data → empirical work produces results → [report](../../report/SKILL.md) packages results into structured artifacts → this skill turns those artifacts into a paper (use [strict-traceability mode](#strict-traceability-mode) when explicit claim provenance is needed) → [academic-voice.md](academic-voice.md) guides prose throughout, with optional journal adaptation → [revision-plan.md](../../revision-plan.md) handles the R&R if it arrives.
