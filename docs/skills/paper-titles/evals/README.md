# Evaluation protocol

This file is for maintaining the skill. Do not load it during an ordinary title
request. The associated cases are task prompts, not instructional examples to
copy into the model's response.

## Status

The bundle contains 28 authored cases and a comparison protocol. A full comparative
model evaluation has not been run. Five independent behavioral spot-checks from
2026-09-15 are recorded in [review notes](review-notes.md). A structural package check is not evidence
that the new skill writes better titles. Do not report invented success rates,
reviewer judgments, acceptance gains, or citation gains.

The cases are synthetic except for the explicitly supplied publisher-metadata
fixture. They do not contain the user's unpublished manuscript or its numerical
results. The reserved split is a proposed testing convention, not a claim of an
independent, previously unseen benchmark.

## What the evaluation must detect

Test two failure directions separately:

**Overstatement:** An attractive title promises an outcome, mechanism, causal
comparison, or scope that the brief cannot support.

**Underperformance:** A technically faithful title hides the contribution, is
interchangeable with dozens of papers, overburdens the title with caveats, or
unnecessarily weakens a supported result.

A skill that avoids every overstatement by always returning "X and Y" has not
necessarily improved. A skill that produces memorable but misleading titles has
not improved either.

## Suggested comparison

Run each case under the same model, settings, supplied evidence, and tool access:

1. No specialized title skill.
2. The prior committed version (b8c9067), including its references.
3. This revised version.

Use separate fresh contexts. Do not feed one condition's outputs into another.
Keep the model and any available generation settings recorded. Repeat runs when
possible because a single output can be unrepresentative. A single seed is not
an assurance of deterministic generation across systems.

For a case, provide the user request and supplied brief, not its expected-behavior
or disallowed-inference fields. Give those fields to the evaluator. Keep the
reserved cases out of example selection while revising the development prompts.
For a browsing-dependent test, freeze accessible source material or record tool
results so that evidence differences are not confused with skill differences.

## Review in two stages

### Stage A: Eligibility and instruction following

A reviewer who has the supplied brief checks:

- Does each recommended title make a supported substantive promise?
- Are constructs, comparator, evidence type, and essential scope preserved?
- Is the result central rather than an attractive but unsupported side story?
- Is the requested output count, language, and explanation level respected?
- Are missing files, searches, metadata checks, and uncertainty described honestly?

Assess meanings, not isolated forbidden words. A response can legitimately discuss
why "welfare" is unsupported. A model result can legitimately use a causal-looking
verb. A keyword blacklist is not an evidentiary audit.

Record concrete material failures. An ineligible title cannot win simply because
it sounds more appealing.

### Stage B: Editorial usefulness among eligible outputs

Show anonymized outputs in randomized order to readers who know the intended
field. Ask which output they would actually use and why. Compare:

**Contribution recognition:** Can they tell what this particular paper contributes?
**Substantive interest:** Is the puzzle, distinction, quantity, or task consequential?
**Positioning:** Does the abstraction level fit the evidence and audience?
**Language:** Is the title clear, specific, memorable, and economical?
**Portfolio quality:** For brainstorm requests, do alternatives offer meaningful
choices rather than repeated phrasings?

Collect a preference, tie, or neither judgment plus a short reason. Do not treat
these judgments as predictions of journal acceptance or future citations. Avoid
combining all qualities into an arbitrary weighted score that can hide a material
failure.

## Paired tests

PT08/PT09 change an imprecise estimate into evidence of a small effect. PT10/PT11
change unsupported subgroup heterogeneity into a supported contrast. PT12/PT13
change an observational comparison into a randomized intervention.

The title's permitted assertion should change when the evidence changes. Its
substantive object should not change arbitrarily. These pairs help detect both
claim inflation and blanket overcaution.

For an additional invariance test, rename the institution without altering the
contribution. The phenomenon-level framing should largely survive. Then replace
the outcome or comparison: a good title should adapt rather than recycle a hook
that no longer matches.

## Paired-term checks

PT25 tests prediction/prescription when both decision tasks are developed. PT26
offers a tempting pair containing an unmeasured construct. PT27 tests whether the
connector falsely creates a sequence between coexisting organizational processes.
PT28 tests nature/nurture without a forced either/or interpretation. Assess the
meanings and relationship as well as whether the words sound alike.

## Cold-reader check

For a small subset, show readers only the title and ask what they expect the paper
to establish. Compare their descriptions with the supplied brief. Then show the
brief and ask whether the title would disappoint or mislead them. Record genuine
reader responses; an assistant's simulated reader description is a diagnostic,
not independent human validation.

## Report and revise

Report claim failures separately from editorial preferences, and inspect results
by contribution type. A gain on AI-platform contrasts does not demonstrate a gain
on theory, descriptive, methods, or qualitative papers.

Maintain an error log: case, failed promise or missing strength, source passage,
and the smallest skill change likely to address it. Recheck both directions after
changing a rule. Adding a warning that fixes overstatement may also weaken a
perfectly supported causal or theoretical title.

The intended improvement is a better set of faithful, useful choices—not maximum
length, minimum length, maximum novelty, or universal paradox language.
