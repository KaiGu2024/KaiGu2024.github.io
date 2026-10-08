# Revision spot-checks — 2026-09-15

One independent subagent read the revised skill and completed five synthetic tasks.
It received the requests and briefs without the expected-behavior fields. The
authoring agent reviewed the answers against the briefs. These are informal
behavioral checks, not a comparison against the prior version or a human-reader
study. The pass used the inherited session model; an exact runtime model identifier
was not recorded. No acceptance, readership, or citation gain is inferred.

## Paired concepts

**PT25, prediction and prescription.** The three returned titles were:

1. Prediction and Prescription in Promotion Targeting
2. Likely Buyers or Persuadable Customers? Choosing Promotion Targets
3. Forecasting Purchases and Choosing Whom to Target: Evidence from a Randomized Promotion Experiment

The first was recommended, with an explanation distinguishing purchase forecasting
from choosing targets based on promotion response. Review: the central comparison
remained visible and no profit or welfare claim was introduced.

**PT26, unsupported polarization.** Returned title:

> Personalization and Purchasing: Tailored Product Rankings Increase Conversion

The response explained that polarization was not measured. Review: it supplied
a usable alliterative alternative and preserved the supported causal finding.

**PT27, adoption and adaptation.** Returned title:

> Adoption and Adaptation: Algorithmic Advice in Lending Teams

The rationale tied “and” to interacting processes. Review: the answer distinguished
the concepts without introducing a temporal sequence or exclusive alternatives.

## Evidence changes with the topic held constant

The PT12 and PT13 briefs were used with the same modified request:
“Give exactly one title, nothing else.”

For the observational ordering-practice survey, the answer was:

> Automated Ordering and Reported Stockouts in Retail Stores

For the randomized ordering intervention, the answer was:

> Automated Ordering Reduces Stockouts in Retail Stores

Review: both obeyed the one-title output request. Wording changed with the
evidence, retaining the stockout outcome and avoiding an unmeasured profit claim.

## Interpretation

No material claim or instruction-following problem was found in these five outputs.
This limited pass does not establish performance on all 28 cases or improvement
over the previous skill. The nature/nurture case PT28 remains authored but unrun.

## 2026-10-08 revision checks

One fresh subagent used the repository's version 2.3.0 skill to answer seven
synthetic requests. It received only each user request and supplied brief, plus
the skill path. It was instructed not to read this evaluation directory, browse,
or modify files. All seven requests shared that fresh context; this was not a
separate-context comparative experiment. The authoring agent assessed the outputs
against the briefs afterward. The agent inherited the session model; no exact
runtime model identifier was recorded.

| Case | Returned recommendation | Review against the brief |
|---|---|---|
| PT29 | Waiting for Water | Chose the human practice and explained why a subtitle was unnecessary; added no measured effect or mechanism. |
| PT30 | Identifying Pipe Leaks from Sparse Pressure Measurements | Kept the technical task and constraint; rejected a human-experience implication absent from the paper. |
| PT31 | The Economic Consequences of Floods | Accepted the subject title for the integrated analysis without treating it as an exhaustive universal claim. |
| PT32 | Electricity Reconnection after a Flood | Narrowed the same proposed broad title to the actually observed service and recovery profile. |
| PT34 | Automatic Refunds Increase Repeat Purchases | Retained the supported causal answer and rejected an unmeasured forgiveness implication. |
| PT35 | Why Shops Stay Empty | Preserved persistence and returned exactly one title. |
| PT36 | Passing the Buck | Used the idiom's established figurative meaning without inventing a literal monetary transfer. |

No material claim or output-instruction failure was found in these seven answers.
PT33 was added but not run; the earlier 28 cases were not rerun. This check supports
the specific intended behaviors above, not overall superiority, title performance
with human readers, or improvement over a prior skill version.

The standard skill validator, JSON case structure and reciprocal pairs, local
reference links and anchors, and whitespace checks passed. These are package
checks, not evidence of better titles.
