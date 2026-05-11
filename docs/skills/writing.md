---
name: writing
description: Use when drafting any paper section for an empirical economics / marketing paper — abstract, introduction, framing, contribution paragraph, results, mechanism, discussion, or conclusion. Triggers on "draft this section", "rewrite my intro", "help me with this paper", "what should I say about X in §3", "summarize this for an abstract", as well as explicit section names. Top-journal template (AER, QJE, Econometrica, JPE, Marketing Science): five-sentence abstracts, contribution-first introductions, results sections that lead with the number. Consumes artifacts from report.md; the inverse of revision-plan.md.
allowed-tools: Read, Edit, Write
invocation: auto
---

# Academic Writing

Academic writing is **contribution display**, not exposition. The reader is a busy referee skimming on a train, and the introduction has three pages to convince them the paper is worth the rest of their attention. This skill consumes the artifacts that [report.md](report.md) produces and turns them into the abstract, introduction, results, and conclusion of a paper.

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

- **Para 1 — The question.** What we ask. Four to six sentences. Forbidden openings: importance of the field, history of the debate, philosophical motivations, lit summary. Open with the question itself or with the wedge tension from [brainstorm.md](brainstorm.md).
- **Para 2 — What we do.** The data, the method, the source of variation. Concrete: name the dataset, the sample, the time period, the identifying assumption. After this paragraph the reader should know whether the strategy is RCT, DiD, RD, IV, synthetic control, or structural.
- **Paras 3–4 — What we find.** Headline number first. Direction, magnitude, precision. Then the secondary findings that earn their seat in the abstract. Don't tease — give the answer.
- **Paras 5–6 — Why it's hard, how we solve it.** What threatens identification, why your strategy clears the threat, and what residual concerns the reader is permitted to keep. Be honest; the reviewer's first instinct is to find the assumption you skipped.
- **Paras 7–8 — Mechanism and interpretation.** What the estimate means structurally. Link reduced form to economic content. If you have a structural model, this is where it enters.
- **Paras 9–10 — Contribution to literature.** Two to four strands. Each one short paragraph. State exactly what is new — *not* "we add to the literature on X" (vague), but "in contrast to Smith (2018), who finds Y in setting Z, we find ¬Y in setting Z′ because…". This is where the literature review lives. Cochrane's rule: never put the lit review *before* your contribution.
- **Para 11 — Roadmap.** "Section 2 introduces the data. Section 3 presents the design. Section 4 reports the main results. Section 5 discusses mechanisms. Section 6 concludes."

The Card-Krueger archetype is the cleanest template: question → natural experiment + data → headline (no employment loss) → identification defense → mechanism → contribution → roadmap. Most empirical papers can be written against that skeleton.

**Annotated opening paragraph** (synthetic, illustrative):

> *Does increasing the minimum wage reduce employment in low-wage industries?* `[Q]` *Standard competitive theory predicts a fall in employment proportional to the labor-demand elasticity, but the elasticity itself has been estimated with sufficient noise that the textbook prediction is rarely tested cleanly in U.S. data.* `[tension]` *We exploit a 1992 increase in New Jersey's minimum wage from $4.25 to $5.05, with neighboring Pennsylvania as a contemporaneous control, to provide a difference-in-differences estimate of the employment response.* `[what we do — preview of Para 2]` *In contrast to the standard prediction, employment in fast-food restaurants rose **13%** in New Jersey relative to Pennsylvania.* `[result preview]`

Each sentence is doing exactly one job. Nothing decorates.

---

## Movement 3 — Results

"Tell, don't dump." The empirical-econ visual norm: one figure carries the punchline; tables carry the precision.

1. **Headline figure.** One figure that captures the main result. Often a comparison: treatment vs. control over time, NJ vs. PA employment, a mobility heatmap, a binscatter against the wedge variable. The reader who sees only the figure should leave with the right belief. See [visualization.md](visualization.md) for execution.
2. **Main table.** Headline regression. Point estimate, standard error, sample, controls, fixed effects. State both economic and statistical significance. Pair every estimate with uncertainty (95% CI or SE — never alone).
3. **Mechanism tests.** Two to three. Pre-specified — state the prediction *before* the test. If A is the channel, B should appear in subsample C. Report the prediction direction in the text and the result in the table.
4. **Heterogeneity.** Theoretically motivated cuts; cite which mechanism predicts which cut. Lifts directly from [report.md](report.md) §Heterogeneity.
5. **Robustness.** Alternative samples, measures, specifications, placebo, falsification. One robustness table is usually enough; the rest goes to the appendix. Robustness should be exhausting to write — that is the point.
6. **Comparison with prior estimates.** Explicit, with the table from [report.md](report.md) §Benchmark. Where estimates differ, name the most plausible reconciliation: data difference (sample, period), measure difference, or method difference.

For structural papers, follow DellaVigna's order: present moments → identification logic → estimates → welfare counterfactuals. Reduced-form moments come first because they anchor the model in a fact the reader can see.

Each results subsection follows the [report.md](report.md) Description / Takeaway split. Description is what the table or figure shows; Takeaway is what we conclude.

---

## Movement 4 — Discussion and Conclusion

Short. The temptation is to repeat the introduction; resist.

- Restate the finding in one sentence.
- Acknowledge the dominant limit honestly. Don't fish for praise — the reader can tell.
- Speculate on policy or future research with the word *speculative* attached. Cochrane allows speculation if it is labeled.

McCloskey: don't pad. Cochrane: short conclusions are fine. Two pages is more than enough.

The honest-limits paragraph is seeded by [report.md](report.md) §Limitations: name the threat to validity that would most change the conclusion if addressed, and suggest the next study.

---

## Movement 5 — Cross-cutting writing rules

Distilled from McCloskey's *Economical Writing* and Cochrane's *Writing Tips*:

- **Lead with the result, not the motivation.** The reader wants to know what they will learn before deciding whether to read it.
- **Concrete numbers beat vague summary.** "N = 14,203, 47 duplicates removed, 0.3% missingness on the outcome" beats "the dataset was cleaned."
- **Pair every estimate with uncertainty.** SE or 95% CI alongside a point estimate. Bare numbers are unreadable.
- **Active voice, first person plural.** "We estimate" beats "It is estimated."
- **One sentence, one idea.** Shorter sentences read faster and survive translation.
- **No throat-clearing.** Cut "It is well known that…", "Recently…", "An important question is…", "In this paper, we will…".
- **Bold key terms, numbers, conclusions.** Matches the [report.md](report.md) convention.
- **Use → for logic chains.** "high churn → low LTV → unprofitable segment." Matches [report.md](report.md).
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

Section templates (Methods / Results / Discussion slots) live in [`report`](report.md) §Paper-section Templates. Map each slot to the input that supplies it; slots with no source become `[TODO]` markers, never silent omissions.

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

The gap inventory is visible — every line that needs a number, every reference that needs resolving — before the section is circulated. Pair with [`literature-review`](literature-review.md) Path A to resolve `[CITE: handle]` strings into verified DOIs.

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

The flow: [brainstorm.md](brainstorm.md) produces a question → [literature-review.md](literature-review.md) and [eda.md](eda.md) verify it → empirical work produces results → [report.md](report.md) packages results into structured artifacts → this skill turns those artifacts into a paper (switch to Movement 7's strict-traceability mode for sections where claim provenance matters more than narrative flow) → [academic-voice.md](academic-voice.md) does the final voice pass for the target journal → [revision-plan.md](revision-plan.md) handles the R&R if it arrives.

---

## Worked example — annotating an intro paragraph

A reverse-engineered Card-Krueger opening, sentence by sentence:

> *Does increasing the minimum wage reduce employment in low-wage industries?*

The question. Bare interrogative. No buildup.

> *Standard competitive theory predicts a fall in employment proportional to the labor-demand elasticity, but the elasticity itself has been estimated with sufficient noise that the textbook prediction is rarely tested cleanly in U.S. data.*

The tension — the puzzle peg from [brainstorm.md](brainstorm.md). Theory says X; data has not really been allowed to disagree.

> *We exploit a 1992 increase in New Jersey's minimum wage from $4.25 to $5.05, with neighboring Pennsylvania as a contemporaneous control, to provide a difference-in-differences estimate of the employment response.*

What we do — naming the variation, the geography, the period, and the strategy. The reader knows in twenty-five words that this is a DiD on a real policy event.

> *In contrast to the standard prediction, employment in fast-food restaurants rose **13%** in New Jersey relative to Pennsylvania.*

The result. Headline number, direction, comparison group. No teasing. The remaining intro will defend the design and lay out the contribution; the reader already has the punchline.

If your opening paragraph cannot be annotated this cleanly — sentence by sentence, each doing one job — it is not yet ready. Revise until it is.
