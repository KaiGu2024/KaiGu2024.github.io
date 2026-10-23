# Null averages and heterogeneous effects

A null average can reflect an effect concentrated in one subgroup or positive and negative effects that offset. Keep the overall specification as a benchmark and ask which baseline conditions change the response. Study heterogeneity whether or not the average is significant.

## Define the claim and conditions

Choose a small set of baseline modifiers from mechanisms, institutions, or prior evidence, retaining continuous measures where useful. Grouping by treatment-induced behavior instead targets selection or mediation. Record hypotheses and explored cutoffs using [§3's planning rules](../SKILL.md#3-plan-a-limited-set-of-justified-adjustments); apply [§5's interpretation and multiplicity rules](../SKILL.md#5-separate-identification-magnitude-and-precision) to the subgroup claims.

## Estimate and compare effects

1. **Define comparable targets.** State each subgroup's treatment contrast, outcome units, horizon, cohort support, eligible controls, and weights. Choose an estimator compatible with treatment timing and heterogeneous effects using [§4](../SKILL.md#4-match-the-estimator-to-the-design).
2. **Test the difference.** Report each subgroup effect and a direct contrast, such as \(\tau_A-\tau_B\), with intervals. Use joint covariance or joint resampling that respects assignment clusters, shared controls, and fitted components. Different significance labels do not establish a difference; assess uncertainty in both subgroup signs and their contrast. [L19]
3. **Explain the average.** For a common target partitioned into exhaustive, nonoverlapping subgroups, aggregate effects using its population weights and report subgroup shares and contributions. Distinguish dilution by a small affected subgroup, offsetting effects, and low precision. Reconcile sample, horizon, cohort-weight, or conventional TWFE differences before interpreting cancellation. [L1]

## Evaluate the trend assumption for the actual claim

Flat pooled pre-trends can mask opposing subgroup discrepancies. Examine pre-treatment treated-versus-comparison contrasts within each relevant subgroup, including magnitude, uncertainty, support, and composition. Apply §5's diagnostic and sensitivity workflow to the subgroup effect or contrast being claimed, retaining its covariance. [L8, L11]

**A relative effect can use a different identifying assumption.** In a triple-difference design, common untreated trend bias across subgroup DiDs can cancel in their difference. Explain why that restriction is plausible and examine the preperiod differential contrast. Under that restriction, the contrast identifies the effect difference; each subgroup's absolute effect or causal sign needs its own identifying argument. [L20]

## Present the result

Lead with the overall estimate, the condition under which responses differ, and the subgroup effects and direct contrast with uncertainty. Follow [§6](../SKILL.md#6-present-the-supported-conclusion-and-preserve-the-audit-trail) for presentation and diagnostic reporting; a table or coefficient plot can carry the argument.

For example: “The average effect is close to zero. The effect is positive among A and negative among B, and their weighted contributions largely offset.” Use this interpretation when the estimates and identification support both signs. For an identified relative contrast, say “The effect is larger in A than B.” Describe a wide subgroup interval as imprecise.

Sources [L1, L8, L11, L19, L20] are in the [literature guide](../references/literature.md).
