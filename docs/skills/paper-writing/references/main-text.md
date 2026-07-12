# Main Text — drafting the paper

Academic writing is **contribution display**, not exposition. The reader is a busy referee skimming on a train, and the introduction has three pages to convince them the paper is worth the rest of their attention. This skill consumes the artifacts that [report.md](../../report.md) produces and turns them into the abstract, introduction, results, and conclusion of a paper.

The dominant template across top empirical-economics journals — AER, QJE, Econometrica, JPE, Marketing Science — is consistent enough to learn by pattern. What follows is that pattern, with the rules that make it work.

---

## Movement 1 — Abstract

Five sentences, ~150 words, written last and placed first.

1. **Question + significance.** What we ask, why it matters. No philosophy. No "Recently…". No "It is well known that…".
2. **Data + method.** N, source, identifying variation. Concrete: name the dataset and the strategy.
3. **Main result with magnitude.** The number. Direction, size, precision. One or two sentences.
4. **Mechanism or heterogeneity.** Where the effect comes from, or where it concentrates.
5. **Implication or contribution.** What the field now knows that it didn't.

Cochrane: "start with what you do… start with the main result." McCloskey's thirty-five rules collapse into one: every word earns its place. Cut throat-clearing, cut warmups, cut philosophical preamble.

**Annotated example** (synthetic, in the style of Card-Krueger):

> *We test whether minimum-wage increases reduce employment in low-wage retail.* `[Q + significance]` *Using New Jersey's 1992 wage hike with eastern Pennsylvania as a control, we surveyed 410 fast-food restaurants before and after the policy.* `[Data + method]` *Employment in New Jersey rose by **13 percent** relative to Pennsylvania, contrary to the textbook prediction of a 1–3 percent decline.* `[Result with magnitude]` *The increase concentrates in stores that were paying close to the old minimum and is not driven by changes in store openings or hours.* `[Mechanism]` *The findings reject the standard competitive-market model for this segment of the labor market.* `[Implication]`

Notice what is not there: no claim that employment is important, no history of the minimum-wage debate, no assertion that the question is "long-standing".

---

## Movement 2 — Introduction

The Cochrane structure dominates top-5 empirical economics. Cap at three pages. Eleven paragraphs is a generous upper bound.

- **Para 1 — The question.** What we ask. Four to six sentences. Forbidden openings: importance of the field, history of the debate, philosophical motivations, lit summary. Across recent award-winning empirical papers the dominant opening is *not* the bare question — it is the **status-quo mechanism the paper disrupts**: the prior equilibrium, arrangement, or received belief you will show is breaking ("the conventional wisdom is X; we challenge it"). That is the default. The wedge tension from [brainstorm.md](../../brainstorm.md) is the second option; opening with the bare question itself is the lean exception, not the rule. The status-quo opening is not throat-clearing when the mechanism *is* the economic object: describing how the system worked is what makes the disruption legible, and it should resolve into the question by the end of the paragraph, not linger. If the paper hinges on a **new construct**, define it precisely in the opening rather than assuming the reader shares your meaning, and consider a single conceptual schematic — an architecture or mechanism diagram contrasting the old and new regimes, *not* a results figure — placed in the introduction. This is the one figure that belongs before Movement 3.
- **Para 2 — What we do.** The data, the method, the source of variation. Concrete: name the dataset, the sample, the time period, the identifying assumption. After this paragraph the reader should know whether the strategy is RCT, DiD, RD, IV, synthetic control, or structural.
- **Paras 3–4 — What we find.** Headline number first. Direction, magnitude, precision. Then the secondary findings that earn their seat in the abstract. Don't tease — give the answer. But mind *where*: the **abstract** leads with the magnitude; the **introduction** delivers it here, after the setup (typically the third to fifth paragraph), not in the opening line. Award-winning intros lead with the tension and reach the number once the question and design are on the table — the result lands mid-intro, not in Para 1.
- **Paras 5–6 — Why it's hard, how we solve it.** What threatens identification, why your strategy clears the threat, and what residual concerns the reader is permitted to keep. Be honest; the reviewer's first instinct is to find the assumption you skipped.
- **Paras 7–8 — Mechanism and interpretation.** What the estimate means structurally. Link reduced form to economic content. If you have a structural model, this is where it enters.
- **Paras 9–10 — Contribution to literature.** Two to four strands. Each one short paragraph. State exactly what is new — *not* "we add to the literature on X" (vague), but "in contrast to Smith (2018), who finds Y in setting Z, we find ¬Y in setting Z′ because…". This is where the literature review lives. Cochrane's rule: never put the lit review *before* your contribution. The contribution itself can be organized three ways, all common in award papers: as the **two-to-four literature strands** above; **split by audience** (a "conceptually… / practically…" or "policy… / methodological…" pair); or as an **enumerated list** ("we make three contributions: First… Second… Third…"). Pick one and commit. Then **bound the claim** in one sentence: state what the paper does *not* assert (e.g. "we measure a change in observable behavior, not consumer welfare"). Naming the contribution's limit pre-empts the referee's first overreach objection and reads as confidence, not retreat — an unbounded claim invites the reader to find the boundary for you.
- **Para 11 — Roadmap.** "Section 2 introduces the data. Section 3 presents the design. Section 4 reports the main results. Section 5 discusses mechanisms. Section 6 concludes."

The Card-Krueger archetype is the cleanest template: question → natural experiment + data → headline (no employment loss) → identification defense → mechanism → contribution → roadmap. Most empirical papers can be written against that skeleton.

**Annotated opening paragraph** (synthetic, illustrative):

> *Does increasing the minimum wage reduce employment in low-wage industries?* `[Q]` *Standard competitive theory predicts a fall in employment proportional to the labor-demand elasticity, but the elasticity itself has been estimated with sufficient noise that the textbook prediction is rarely tested cleanly in U.S. data.* `[tension]` *We exploit a 1992 increase in New Jersey's minimum wage from $4.25 to $5.05, with neighboring Pennsylvania as a contemporaneous control, to provide a difference-in-differences estimate of the employment response.* `[what we do — preview of Para 2]` *In contrast to the standard prediction, employment in fast-food restaurants rose **13%** in New Jersey relative to Pennsylvania.* `[result preview]`

Each sentence is doing exactly one job. Nothing decorates.

---

## Movement 3 — Results

"Tell, don't dump." The empirical-econ norm is that *something* carries the punchline and the rest carries the precision — but it is not always a figure. Across award papers the punchline is carried by a figure, by a **single headline number repeated verbatim**, or by one decisive table about as often as by a plot. Lead with whichever the reader will remember; let tables carry the precision behind it.

1. **Headline figure.** One figure that captures the main result. Often a comparison: treatment vs. control over time, NJ vs. PA employment, a mobility heatmap, a binscatter against the wedge variable. The reader who sees only the figure should leave with the right belief. See [visualization.md](../../visualization.md) for execution.
2. **Main table.** Headline regression. Point estimate, standard error, sample, controls, fixed effects. State both economic and statistical significance. Pair every estimate with uncertainty (95% CI or SE — never alone).
3. **Mechanism tests.** Two to three. Pre-specified — state the prediction *before* the test. If A is the channel, B should appear in subsample C. Report the prediction direction in the text and the result in the table.
4. **Heterogeneity.** Theoretically motivated cuts; cite which mechanism predicts which cut. Lifts directly from [report.md](../../report.md) §Heterogeneity.
5. **Robustness.** Alternative samples, measures, specifications, placebo, falsification. One robustness table is usually enough; the rest goes to the appendix. Robustness should be exhausting to write — that is the point.
6. **Comparison with prior estimates.** Explicit, with the table from [report.md](../../report.md) §Benchmark. Where estimates differ, name the most plausible reconciliation: data difference (sample, period), measure difference, or method difference.

For structural papers, follow DellaVigna's order: present moments → identification logic → estimates → welfare counterfactuals. Reduced-form moments come first because they anchor the model in a fact the reader can see.

Each results subsection follows the [report.md](../../report.md) Description / Takeaway split. Description is what the table or figure shows; Takeaway is what we conclude.

**Interpreting the numbers — three moves the award papers share:**

- **Repeat the headline number verbatim.** The single most important magnitude should appear identically in the abstract, the introduction, and the conclusion — same figure, same framing. A number the reader meets three times is the number they leave with. Drifting it (13% here, "about 13" there, "roughly an eighth" later) tells the reader you don't trust it.
- **Handle nulls without over-claiming.** A failure to reject is not evidence of equivalence. Say "we cannot detect a difference; the estimate is consistent with effects between −x and +y," and attribute the silence to power or remaining uncertainty — never "there is no effect." Bound what the null rules out rather than declaring zero.
- **End the interpretation on a one-line verdict.** After the Description / Takeaway split, distill the section's conclusion into a single quotable sentence — the "this is a data problem, not a model problem" move. The verdict is what gets quoted in the referee report and the seminar; write it deliberately rather than leaving the reader to compose it.

---

## Movement 4 — Discussion and Conclusion

Short. The temptation is to repeat the introduction; resist. The recurring four-part shape across award papers is: **restate → implications → limitations → labeled speculation.**

- **Restate the finding in one sentence** — the central reframing, re-asserting the headline number verbatim (Movement 3) and any "first to…" claim.
- **Implications, often split by audience.** When a finding lands on more than one constituency, address them in turn rather than in one blur — a paragraph (or labeled sub-paragraph) per stakeholder: publishers / advertisers / regulators; researchers / industry; theory / practice. The split shows you know who pays for the result, and it pre-empts "what does this mean for X?"
- **Acknowledge the dominant limit honestly.** Don't fish for praise — the reader can tell. Award papers frame limitations three ways, and the framing matters: (1) an **explicit, sometimes numbered list** owning specific design choices; (2) a **data-availability constraint** — "we observe desktop, not cross-device" — which reads as scope, not flaw; (3) **woven-in caveats** at the point each result is stated. Owning the limit as scope-or-data beats confessing it as failure; either beats hiding it.
- **Speculate with the word *speculative* attached** — Cochrane allows speculation if it is labeled. The strongest closing move is **speculative elevation**: tie the specific finding up to the broader principle it illuminates (a classic critique, a reusable framework, the next regime), explicitly flagged as speculation. End on the bigger idea, not a summary.

McCloskey: don't pad. Cochrane: short conclusions are fine. Two pages is more than enough — even the longest award conclusions run only a handful of paragraphs.

The honest-limits paragraph is seeded by [report.md](../../report.md) §Limitations: name the threat to validity that would most change the conclusion if addressed, and suggest the next study.

---

## Movement 5 — Cross-cutting writing rules

Distilled from McCloskey's *Economical Writing* and Cochrane's *Writing Tips*:

- **Lead with the result, not the motivation.** The reader wants to know what they will learn before deciding whether to read it.
- **Concrete numbers beat vague summary.** "N = 14,203, 47 duplicates removed, 0.3% missingness on the outcome" beats "the dataset was cleaned."
- **Pair every estimate with uncertainty.** SE or 95% CI alongside a point estimate. Bare numbers are unreadable.
- **Active voice, first person plural.** "We estimate" beats "It is estimated."
- **One sentence, one idea.** Shorter sentences read faster and survive translation.
- **No throat-clearing.** Cut "It is well known that…", "Recently…", "An important question is…", "In this paper, we will…".
- **Bold key terms, numbers, conclusions.** Matches the [report.md](../../report.md) convention.
- **Use → for logic chains.** "high churn → low LTV → unprofitable segment." Matches [report.md](../../report.md).
- **Write early, revise late.** Varian: writing is part of thinking, so start before the analysis is finished. McCloskey: every revision pass should remove words.
- **Audience: the busy referee.** Imagine them on a train, with thirty minutes, deciding among reject / R&R / accept. Write so they can decide on the abstract and intro alone.
- **Offload the banal, protect the important.** Boilerplate emails, regression-table summaries, section roadmaps, and reference-list cleanup are safe targets for LLM assistance. The wedge sentence, the framing, the contribution paragraphs, and the limits paragraph are not.

---

## Movement 6 — Working with Claude on prose

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

The default editing prompt:

> *"Edit the following section in the style of a NYT editor for writing and clarity. Do not edit my text directly. Instead, insert inline comments where the argument is poor, the prose is unclear, or a claim is unsupported."*

Why this works:
- The original text is preserved; you read each comment and decide your response.
- Forces active engagement — you cannot passively accept LLM prose because no LLM prose is produced.
- Preserves voice. The most common failure mode of LLM-assisted writing is unintended convergence to the model's average style; comment-mode blocks that.

Use Claude Code (or another file-aware harness) for this — the chat web UI cannot read and annotate the actual draft cleanly.

### The AI tells — a self-audit

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
  - **Passive voice is fine when the actor is irrelevant** — "samples were normalized to total protein." Recast passives only where naming the agent adds information (Movement 5's active-voice rule targets *those*, not all passives).
  - **First-person plural "we" is standard** — do not rewrite to avoid it.
  - **Semicolons and an occasional triple** are fine in moderation; only the em-dash is removed outright.
  - **Definitions, named methods/metrics, symbols, equations, and every number and citation stay verbatim.**

  The two disciplines run together: remove the tells, but never at the cost of a verb that was correctly calibrated to its evidence.

**Why it matters (the empirical case):** detectably-AI work is penalized by evaluators (Reif/Larrick/Soll 2025; Raj/Berg/Seamans 2026), and over-reliance homogenizes output — more text per author, fewer distinct ideas across a field (Anderson 2024; Doshi & Hauser 2024; Moon 2025). Distinctiveness is the asset; generic confidence is not a substitute for specific reasoning. (Adapted from the MGMT430 *"Using AI without sounding like AI"* lecture; the slide-deck counterpart — *visual* tells — lives in [`slide/references/aesthetics.md`](../../slide/references/aesthetics.md).)

### The accountability test

Before sending a draft to a coauthor or referee, ask: *"Can I defend every paragraph in this section without the LLM open?"* If the answer is no for any paragraph, that paragraph is not yet yours. Rewrite it by hand, or delete it. The 1977 IBM rule — a computer cannot be held accountable, therefore a computer cannot make the editorial decision — applies to every sentence the paper claims under your name.

Do not draft with Claude when tired. The output looks fine and isn't, and you stop pushing back.

---

## Movement 7 — Strict-traceability mode

The default movements above are flow-first: get the structure right, draft against the Cochrane template, polish later. **Strict-traceability mode** is the inverse — slow down, accept no claim that doesn't trace to a specific input, and flag every gap explicitly. Use it when the cost of an invented number outweighs the cost of a slower draft.

**When to switch on:**

- Methods sections — one fabricated detail sinks credibility
- Results sections drafted directly from regression output, where misreading a coefficient is unacceptable
- Discussion sections drafted against fieldnotes or interview matrices, where misattributing a quote breaks trust
- Any section the user wants to read with the inputs open in another window and check claim-by-claim

The accountability test from Movement 6 — *"can I defend every paragraph without the LLM open?"* — is the same idea applied at paragraph granularity. Strict-traceability mode applies it at *claim* granularity.

**Three rules — non-negotiable:**

1. Every empirical claim traces to a `file:line` in the input. If it cannot, the line gets `[TODO: source]`.
2. Every reference to a paper, dataset, or method uses a `[CITE: short-handle]` placeholder. Never invent author-year strings.
3. Numbers absent from the input become `[TODO: number]` placeholders. Never guess a coefficient, p-value, or N.

**Workflow:**

```
identify section + inputs → load template → map inputs to slots → draft → emit TODO/CITE checklist
```

Section templates (Methods / Results / Discussion slots) live in [`report`](../../report.md) §Paper-section Templates. Map each slot to the input that supplies it; slots with no source become `[TODO]` markers, never silent omissions.

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

## Movement 8 — Terminology anchoring

A draft can be structurally clean and still name its objects wrong. When a paper coins its own label for a construct the literature already names — "engagement decay" for what the field calls *churn*, "attention spillover" for *demand cannibalization* — the referee reads it as not-having-read-the-literature, and the contribution gets discounted before the result is even weighed. The fix is not to flatten every term into the nearest cliché; coining is sometimes the contribution (Movement 2's *new construct*). It is to make the choice **deliberate**: anchor to the literature's term where you are describing a known object, and reserve a coined term for where you are genuinely introducing one.

This is a **polish pass**, run after the draft has structure and content, not a drafting step. It round-trips with [`literature-review`](../../literature-review.md): the skill that resolves `[CITE: handle]` strings is the same one that knows how the anchoring papers name each construct.

**When to run it.** After Movement 2–4 drafting, before the [`academic-voice.md`](academic-voice.md) pass. Especially when the paper sits on top of an established literature whose vocabulary the referee will expect, or when the draft was written fast and may have drifted into ad-hoc labels.

**Three steps:**

1. **Extract the construct/method terms.** Scan the section for the nouns and noun phrases that name an economic object, a mechanism, a measure, or a method — the words a referee would expect to map onto a known concept. Skip ordinary prose; collect the load-bearing terms. Output a list, each with the sentence it appears in, so the term is judged in context (the same word can be load-bearing in one sentence and incidental in another).
2. **Find the literature-anchored term for each.** Hand the list to [`literature-review`](../../literature-review.md) Path A: for each extracted term, retrieve how the anchoring papers (the ones the paper already cites, plus the canonical refs for that construct) name the same object. Some terms will map cleanly to a standard label; some will have two or three competing conventions; some will have no established anchor, which is itself the signal that the term may be a genuine coinage.
3. **Emit a diff, never a silent rewrite.** For each term, propose: keep, or replace with the anchored term — with the citation that licenses the anchored choice and a one-line reason. The author decides. Three verdicts:
   - **Anchor** — the draft drifted from a settled term; replace it and cite. ("'engagement decay' → *churn* [CITE: reichheld1996]; field uses *churn* for exactly this hazard.")
   - **Choose** — two or three conventions compete; surface them with their citations and let the author pick the one whose framing fits the contribution. Do not pick silently.
   - **Coin** — no established anchor, or the author is deliberately introducing a construct. Keep the term, but flag that it needs the explicit definition Movement 2 requires for a new construct, and that it should *not* be quietly swapped for a near-synonym elsewhere in the paper.

**Output shape** — a per-term table the author reads top to bottom:

```
## Terminology anchoring
| Draft term | Verdict | Anchored term | Licensing cite | Note |
|---|---|---|---|---|
| engagement decay | anchor | churn | [CITE: reichheld1996] | settled term for this hazard; draft drifted |
| attention spillover | choose | cannibalization / demand diversion | [CITE: ...] | two conventions; pick by framing |
| trust transfer | coin | — | — | no anchor; define it (Movement 2), don't synonym-swap later |
```

The discipline mirrors Movement 7's: the skill never silently changes the word the author chose — it surfaces the literature's term, the citation that licenses it, and the reason, then leaves the editorial decision with the author. Anchoring to a borrowed term and coining a new one are both defensible; drifting into an ad-hoc label by accident is not.

This pass also feeds the `feedback_prose_restraint` discipline ("prefer literature-anchored terms") with a mechanism rather than a reminder: the anchored term comes back with a verified citation, not from model memory.

---

## How `report.md` artifacts feed into the paper

| Report artifact | Lands in |
|---|---|
| §1 Data & Sample | Para 2 of intro + Data section + Abstract sentence 2 |
| §2 Definitions | Measurement section (brief in body, full in appendix) |
| §3+ Analyses | Results subsections; Description / Takeaway split preserved |
| §Heterogeneity | Its own Heterogeneity section |
| §Benchmark | Discussion / Comparison subsection before the conclusion |
| §Limitations | The honest-limits paragraph in the conclusion |

The flow: [brainstorm.md](../../brainstorm.md) produces a question → [literature-review.md](../../literature-review.md) and [eda.md](../../eda.md) verify it → empirical work produces results → [report.md](../../report.md) packages results into structured artifacts → this skill turns those artifacts into a paper (switch to Movement 7's strict-traceability mode for sections where claim provenance matters more than narrative flow) → [academic-voice.md](academic-voice.md) does the final voice pass for the target journal → [revision-plan.md](../../revision-plan.md) handles the R&R if it arrives.

---

## Worked example — annotating an intro paragraph

A reverse-engineered Card-Krueger opening, sentence by sentence:

> *Does increasing the minimum wage reduce employment in low-wage industries?*

The question. Bare interrogative. No buildup.

> *Standard competitive theory predicts a fall in employment proportional to the labor-demand elasticity, but the elasticity itself has been estimated with sufficient noise that the textbook prediction is rarely tested cleanly in U.S. data.*

The tension — the puzzle peg from [brainstorm.md](../../brainstorm.md). Theory says X; data has not really been allowed to disagree.

> *We exploit a 1992 increase in New Jersey's minimum wage from $4.25 to $5.05, with neighboring Pennsylvania as a contemporaneous control, to provide a difference-in-differences estimate of the employment response.*

What we do — naming the variation, the geography, the period, and the strategy. The reader knows in twenty-five words that this is a DiD on a real policy event.

> *In contrast to the standard prediction, employment in fast-food restaurants rose **13%** in New Jersey relative to Pennsylvania.*

The result. Headline number, direction, comparison group. No teasing. The remaining intro will defend the design and lay out the contribution; the reader already has the punchline.

If your opening paragraph cannot be annotated this cleanly — sentence by sentence, each doing one job — it is not yet ready. Revise until it is.
