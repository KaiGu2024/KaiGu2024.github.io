# DiD rename and heterogeneity review

Date: October 23, 2026. Scope: rename `did-adjustment` to `did` and add the direction of a null average with conditional or opposing subgroup effects. Existing estimator, IV, transformation, and historical case modules retain their content.

## Decisions and evidence

- Keep the overall estimate as a benchmark. Distinguish small effects, imprecision, dilution, and cancellation; require comparable targets and aggregation weights before interpreting the average.
- Give the new workflow one home in [guidance](../guidance/null-and-heterogeneous-effects.md). The entrypoint routes to it; the trial template adds only fields needed to retain the subgroup analysis.
- Compare subgroup effects directly. [Gelman and Stern, L19](../references/literature.md#l19-compare-subgroup-effects-directly) supports this distinction from comparing significance labels.
- Assess trend evidence for the claimed effect or contrast. Rechecked [Roth, L8](../references/literature.md#l8-pretest-selection-and-power) and [Rambachan and Roth, L11](../references/literature.md#l11-sensitivity-to-violations-of-parallel-trends): observed pre-trends motivate investigation and explicit assumptions or sensitivity, rather than a universal stop rule.
- Include the relative-effect route. [Olden and Møen, L20](../references/literature.md#l20-identify-a-subgroup-contrast-under-a-triple-difference-restriction), especially §5, supports cancellation of common trend bias in a triple difference. Applying this to heterogeneous responses requires distinguishing the effect difference from each subgroup's effect.
- Make event-study figures optional. Tables and appendix diagnostics can communicate the evidence; material trend discrepancies and their implications remain part of the report. This presentation choice follows the user's preference, not a claim that the cited papers recommend omitting figures.

## Manual scenario walkthroughs

These check written instruction coverage. They are not independent model runs, a benchmark improvement estimate, or an empirical replication.

| Scenario in the [evaluation file](../evals/evals.json) | Supported response |
|---|---|
| 7: null average and different significance labels | Pursue baseline capacity as a substantive modifier, retain the pooled result, and use the supplied contrast interval: it does not establish heterogeneity. Check subgroup trends and avoid searching for a successful cutoff. |
| 8: opposing effects and opposing pre-trends | Recognize that pooled flatness can mask discrepancies. Reconcile weights and targets; assess the subgroup effects and contrast under a justified design or sensitivity range. A table-only presentation is allowed with transparent numerical diagnostics and an appropriately qualified claim. Opposing biases do not cancel in their difference. |
| 9: relative effect with common trend bias | Accept the proposed interpretation conditional on its common-bias restriction and other design assumptions. No need to make each subgroup's leads flat, add mandatory figures, or reopen specification search solely for appearance. The relative contrast does not identify separate causal signs. |

The three earlier scenarios remain unchanged. New prompts are retained for future independent runs; no score is reported from this document review.
