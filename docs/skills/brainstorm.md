---
name: brainstorm
description: Use when the user has a vague research topic and needs to sharpen it into a question — produces one wedge sentence, a labeled contribution type (sharp prediction / question-meets-data / conceptual reframe), and a decomposition tree of three to five sub-questions, each tied to a candidate identification strategy. Output feeds literature-review and eda; without it both are unfocused.
allowed-tools: Read
invocation: auto
---

# Brainstorm

Brainstorming in empirical economics is not idea generation. It is **idea sharpening** — the funnel between a vague topic and the concrete sub-question tree that feeds [literature-review.md](literature-review.md) and [eda.md](eda.md). The output is one **wedge sentence**, a labeled **contribution type**, and a **decomposition tree** of three to five sub-questions, each tied to a candidate identification strategy. Without that, lit review is unfocused and EDA is aimless.

Two movements: **topic → question** (what to ask) and **question → decomposition** (what to test).

---

## Movement 1 — Topic to Research Question

### The wedge

Every empirical paper that lands in a top journal opens a door the literature didn't have. Three archetypes worth pattern-matching against:

- **Sharp prediction that can fail visibly.** Card and Krueger 1994: textbook minimum-wage theory predicts employment falls; the New Jersey wage hike with Pennsylvania as a control makes the test clean. The wedge is the falsifiability — a confident theoretical prior the data is permitted to overturn.
- **Question everyone asks meets data nobody had.** Chetty and Hendren 2014: "Is the US still the land of opportunity?" was rhetorical until forty million tax records made it answerable at the commuting-zone level. The wedge is the data, used to settle a question already in the air.
- **Conceptual reframe of a domain.** Goldfarb and Tucker recast digital marketing as a story about five cost reductions — search, replication, transportation, tracking, verification. The wedge is the lens: apply a clean econ frame to a messy domain and a dozen subquestions fall out.

If your candidate question fits none of the three, it isn't sharp enough yet. Most failures here are quiet — the question is interesting, but no specific door opens when the data comes in.

### Three contribution types

Empirical economics rewards papers that pick exactly one of:

- **New fact.** Measure something previously unmeasured. Chetty's mobility maps; Athey-Imbens heterogeneous treatment effects in real data.
- **New mechanism.** Explain *why* an established fact holds. DellaVigna-style structural recovery of behavioral parameters that rationalize reduced-form moments.
- **New method.** Hand the field a tool. The DiD framework as Card-Krueger deployed it; causal forests in Athey-Imbens-Wager.

Mixed-contribution papers blur. Force the commitment in brainstorming: which of the three is your primary contribution? The other two can appear as secondary, but cannot drive the abstract.

### Gap typology

Gaps come in four kinds. Each routes to a different skill for verification.

- **Theory gap.** A published model predicts X; X has not been tested cleanly, or two models predict opposite signs and the data can adjudicate. Use [literature-review.md](literature-review.md) Path A to map predictions and unresolved bets.
- **Practical gap.** A parameter needed for a real decision — a policy choice, a price, a market design — has not been measured. Use [literature-review.md](literature-review.md) to confirm absence, then talk to practitioners; their absence in the literature *is* the gap.
- **Empirical gap.** New data — administrative records, scraped traces, GenAI logs, platform partnerships — makes a question newly answerable. Use [eda.md](eda.md) to surface what the data actually permits before committing.
- **Method gap.** Existing studies use a strategy with known biases; cleaner identification is now available. Tied to [eda.md](eda.md) (what variation lives in the data) and lit review (what others tried and where they failed).

Brainstorm starts with at least two of these in mind. A theory gap with no empirical gap is hard to publish; an empirical gap with no theory gap is a fact-sheet, not a paper.

### The Heckman-Varian iteration

Don't read the literature first. Varian's *spare-time* method: write down the agents (whose choices?), the constraints, the interactions, the equilibrium adjustment. Simplify until the cleanest version remains. *Then* check what the literature has done.

Heckman and Singer's 2017 *Abducting Economics* extends this into the data: don't separate hypothesis-creation from inference. Successful empirical papers iterate — surprising fact in the data, tentative model, augment the data, revise the model, re-test. Brainstorming is where that iteration happens cheaply, before commitments are sunk in scripts and tables.

The practical implication: hold the model and the data in your head simultaneously. If you find yourself locked into one, switch to the other for ten minutes.

### Using an LLM during brainstorm

Brainstorming is idea *sharpening*, and an LLM can sharpen — or it can quietly substitute for the work and leave you with a wedge sentence you cannot defend. Goldsmith-Pinkham's rules, applied to this stage:

- **Earn the specificity before you prompt.** "Help me think about household savings over the life cycle" returns generic prose. Iterate the wedge sentence and the four pegs by hand first, then bring the LLM in to stress-test what you already have.
- **Load maximum context.** Lit-review notes, prior drafts, the data dictionary, related slide decks, the policy URL that motivated the question. Underspecified prompts return the LLM's average prior, which is your competitor's prior too.
- **Margin-notes mode, not rewrite mode.** Paste your wedge sentence and the decomposition tree, and ask for inline comments — missing branches, weakest assumption, alternative explanations you skipped — *not* a rewritten tree. Read each comment, decide your response. The act of deciding is the brainstorming.
- **Self-test before leaving the stage.** "Can I defend this wedge for ten minutes without the LLM open?" If no, you have a draft of someone else's idea, not yours. Stay in brainstorm.
- **Don't brainstorm with Claude when tired.** The output looks fine and isn't, and you stop pushing back. Bad wedges survive these sessions.

The principle: the LLM is a sounding board, not a co-author of the question. The 1977 IBM rule applies — the model cannot be held accountable, so it cannot make the call.

### Storytelling: the four pegs

The wedge needs a story. Top-5 intros open with four pegs in a specific order:

- **Protagonist.** Whose choices are we explaining? A worker, a household, a firm, a regulator, a platform. Name them.
- **Puzzle.** What does naive intuition predict, and what does the data show? Tension is the engine. No tension, no paper.
- **Why now.** What changed — data availability, a policy event, a technology, a theoretical advance — that makes the question newly answerable? Your reader wants to know why this paper exists in 2026 and not in 2020.
- **Wedge sentence.** "We show **X** — contrary to / extending **Y** — using **Z**." One line. If you can't write it, you don't have a question yet, and going further into the literature or the data is procrastination.

The wedge sentence is the test. It is also what survives onto your job-market poster.

---

## Movement 2 — Question to Decomposition

A question is not yet a paper. It becomes a paper when it decomposes into a tree of sub-questions, each clearing a specific objection from a specific reader.

### The empirical-econ paper anatomy

Read any AER or QJE empirical paper from the last decade and the structure repeats:

1. **One main estimate.** One number, one identification strategy, one comparison. The headline.
2. **Two to three mechanism tests.** If the headline effect comes from channel A, we should see B in subsample C. Pre-specified.
3. **Two to three heterogeneity cuts.** Theoretically motivated — not data-mined. State the predicted direction *before* running the cut.
4. **Five to ten robustness checks.** Alternative samples, measures, specifications. One main robustness table; appendix the rest.
5. **A placebo or falsification.** Something that should *not* show an effect. It reports your discipline back to the reader.
6. **An external-validity discussion.** Where else does this apply? Where doesn't it?

Each layer moves a different skeptic. Brainstorming sketches the tree — not in detail, but enough to know whether the data and design can support all six layers.

### The Goldfarb-Tucker three-step

For every sub-question in the tree, write three lines:

- **Causal arrow.** The specific X → Y you want to estimate.
- **Identification strategy.** RCT, DiD, RD, IV, synthetic control, matching, structural — pick one.
- **Why it recovers the parameter.** The assumption that has to hold; the variation you exploit.

If you cannot fill all three lines for a sub-question, that branch is not yet a research question, it is a hope.

### DellaVigna's structural decomposition

When the question is *why*, layer reduced-form on top of structural. The pattern in DellaVigna's *Structural Behavioral Economics*:

- One reduced-form moment establishes the headline fact.
- Several theory-predicted moments together identify the behavioral parameters.
- Heterogeneity layers in via random effects or mixture-over-types.
- Welfare counterfactuals fall out of the recovered parameters.

Useful when you want both mechanism *and* policy implication. Not needed for fact-only or method-only papers.

### The tree as artifact

What brainstorm hands off to the next stage:

- **Root.** The headline question, in one sentence.
- **Branches** (three to five). Sub-questions covering mechanism, heterogeneity, alternative explanation, scope. Optionally welfare or policy.
- **Leaves.** Each sub-question paired with its candidate identification strategy and the data cut required.

Write the tree as a bulleted list, not a diagram. It will be re-drawn many times.

### Pre-stop checklist

Before leaving brainstorming and committing scripts:

- Can you state the punchline in one sentence?
- Can you sketch the headline figure — axes, comparison, expected shape — on a napkin?
- Can you name two findings that, if true, would *kill* the story?
- Can you explain the contribution to a non-economist in thirty seconds?

If any answer is no, the question isn't ready. Stay in brainstorm.

---

## Worked example — GenAI and households

**Topic** (vague). "How does generative AI affect households?"

**Wedge probe.** Sharp prediction? Yes — household production theory says reducing the cognitive cost of a task should shift time toward that task or away from substitutes, depending on elasticity. Data nobody had? Time-use diaries plus GenAI usage logs from 2023–2025 are now panel-able. Conceptual reframe? Yes — apply the household-production lens to a domain currently dominated by descriptive surveys.

**Contribution type.** New fact (primary): measure the substitution pattern between GenAI use and time-use categories. New mechanism (secondary): identify whether the substitution loads on cognitive vs. routine activities.

**Gaps.** Empirical (new diary + log panel) and theory (prior models predict ambiguous signs depending on which task is automated).

**Story (four pegs).**

- *Protagonist:* household members making time-allocation choices.
- *Puzzle:* lower cognitive cost predicts either more leisure or a reallocation toward education-intensive activities; the data has to pick.
- *Why now:* GenAI usage is broad enough by 2024 to detect time shifts, and ATUS-style diaries can be linked to platform logs.
- *Wedge sentence:* "We show that GenAI adoption substitutes for household time on **educational and informational activities**, not on leisure — extending Becker-style household production by pinning down which task category absorbs the shock."

**Decomposition tree.**

- *Root.* Does GenAI use reallocate household time, and from which activity category?
- *Mechanism.* Does the reallocation load on cognitive-intensive tasks (theory says yes) or on routine tasks (alternative)? → DiD on adoption × task-cognition score.
- *Heterogeneity.* By education and income — the cognitive-cost-reduction hypothesis predicts larger shifts among lower-education users for whom the marginal cognitive cost was higher. → Interaction with education quartiles.
- *Alternative explanation.* Remote-work and pandemic time-use shifts. → Within-user pre/post pandemic comparison.
- *Scope.* Spousal joint activities vs. solo: does the reallocation extend across household members? → Compare matched within-household pairs.

Pre-stop check: punchline statable, headline figure (a difference-in-time-use pre/post adoption split by activity category) sketchable, killer findings identified (no shift, or shift loads only on leisure), thirty-second pitch holds. → ready to leave brainstorm.

---

## Handoff

What this skill produces, fed downstream:

- A one-paragraph **research statement** with the wedge sentence in bold.
- A **contribution-type label** (fact / mechanism / method).
- A **gap label** (theory / practical / empirical / method).
- A **decomposition tree** as a bulleted list, three to five branches deep.

Next: [literature-review.md](literature-review.md) verifies the gap is real; [eda.md](eda.md) checks that the data supports the tree; the empirical-plan stage (out of scope here) translates each leaf into a script.

If brainstorming returns a question that fails the pre-stop checklist after two iterations, the topic itself may be wrong. Return to source material outside academic journals — newspapers, conversations, working domains — in the spirit of Varian, and start again.
